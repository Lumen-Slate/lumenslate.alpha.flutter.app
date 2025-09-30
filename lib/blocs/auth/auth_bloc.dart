import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:lumen_slate/repositories/user_repository.dart';

import '../../models/lumen_user.dart';
import '../../models/students.dart';
import '../../models/teacher.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/teacher_repository.dart';
import '../../services/email_auth_services.dart';
import '../../services/google_auth_services.dart';
import '../../services/phone_auth_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GoogleAuthService googleAuthServices;
  final PhoneAuth phoneAuthServices;
  final EmailAuthService emailAuthService;
  final TeacherRepository teacherRepository;
  final UserRepository userRepository = UserRepository();
  final StudentRepository studentRepository = StudentRepository();
  final _logger = Logger();

  AuthBloc({
    required this.googleAuthServices,
    required this.phoneAuthServices,
    required this.emailAuthService,
    required this.teacherRepository,
  }) : super(AuthInitial()) {
    _logger.i('AuthBloc initialized');
    // googleAuthServices.firebaseUserStream().listen((user) {
    //   if (user == null) {
    //     add(SignOut());
    //   }
    // });

    on<GoogleSignIn>((event, emit) async {
      _logger.i('GoogleSignIn event triggered');
      emit(Loading());
      try {
        _logger.i('Attempting Google sign in');
        Map<String, dynamic>? response = await googleAuthServices.signIn();
        _logger.i('Google sign in response: "+response.toString()+"');
        if (response == null) {
          _logger.w('Google sign in returned null response');
          emit(AuthNotSignedIn());
          return;
        }
        await _handleUserAuthentication(response, emit);
      } catch (e, s) {
        _logger.e('GoogleSignIn error: $e', error: e, stackTrace: s);
        emit(AuthNotSignedIn());
        return;
      }
    });

    on<AuthCheck>((event, emit) async {
      _logger.i('AuthCheck event triggered');
      final userCompleter = Completer<User?>();
      googleAuthServices.firebaseUserStream().listen((user) {
        _logger.i('firebaseUserStream emitted: $user');
        if (user != null && userCompleter.isCompleted == false) {
          userCompleter.complete(user);
        }
      });
      final user = await userCompleter.future.timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          _logger.w('AuthCheck timed out waiting for user');
          return null;
        },
      );
      if (user != null) {
        _logger.i('User found in AuthCheck: ${user.email}');
        final checkUserResponse = await userRepository.getAllUsers({
          "email": user.email!,
          "limit": "1",
          "offset": "0",
        });
        _logger.i(
          'UserRepository.getAllUsers response: ${checkUserResponse.data}',
        );
        if (checkUserResponse.data == null || 
            (checkUserResponse.data as List).isEmpty) {
          _logger.w('No user found in database for AuthCheck');
          emit(AuthNotSignedIn());
          return;
        }
        
        // Create user response map similar to auth flow
        final userData = (checkUserResponse.data as List).first as Map<String, dynamic>;
        final response = {
          'email': user.email,
          'displayName': user.displayName ?? userData['name'],
          'photoUrl': user.photoURL,
        };
        
        // Use the same authentication flow to determine user state
        await _handleUserAuthentication(response, emit);
        event.onSuccess?.call();
      } else {
        _logger.w('No user found in AuthCheck');
        emit(AuthNotSignedIn());
      }
    });

    on<ChooseTeacherRole>((event, emit) async {
      _logger.i(
        'ChooseTeacherRole event triggered for user: ${event.user.email}',
      );
      emit(Loading());
      try {
        _logger.i('Checking if teacher exists for email: ${event.user.email}');
        final response = await teacherRepository.getAllTeachers({
          "email": event.user.email,
          "limit": "10",
          "offset": "0",
        });
        _logger.i(
          'TeacherRepository.getAllTeachers response: ${response.data}',
        );
        Teacher? teacher;
        if (response.data == null) {
          try {
            _logger.i('No teacher found, creating new teacher');
            final createTeacherResponse = await teacherRepository.createTeacher(
              {"name": event.user.name, "email": event.user.email},
            );
            _logger.i(
              'TeacherRepository.createTeacher response: ${createTeacherResponse.data}',
            );
            if (createTeacherResponse.statusCode! >= 200) {
              teacher = Teacher.fromJson(createTeacherResponse.data);
            } else {
              _logger.e(
                'Failed to create teacher: ${createTeacherResponse.data}',
              );
              emit(AuthNotSignedIn());
              return;
            }
          } catch (e, s) {
            _logger.e('Error creating teacher: $e', error: e, stackTrace: s);
            emit(AuthNotSignedIn());
            return;
          }
        } else {
          teacher = Teacher.fromJson(response.data[0]);
        }
        try {
          _logger.i('Updating user role to teacher');
          final updateUserResponse = await userRepository.updateUser(
            event.user.copyWith(role: 'teacher'),
          );
          _logger.i(
            'UserRepository.updateUser response: ${updateUserResponse.data}',
          );
          if (updateUserResponse.statusCode! >= 200) {
            emit(
              AuthSignedInAsTeacher(
                user: event.user.copyWith(role: 'teacher'),
                teacher: teacher,
              ),
            );
            return;
          } else {
            _logger.e('Failed to update user role: ${updateUserResponse.data}');
            emit(AuthNotSignedIn());
            return;
          }
        } catch (e, s) {
          _logger.e('Error choosing teacher role: $e', error: e, stackTrace: s);
          emit(AuthNotSignedIn());
          return;
        }
      } catch (e, s) {
        _logger.e('Error choosing teacher role: $e', error: e, stackTrace: s);
        emit(AuthNotSignedIn());
        return;
      }
    });

    on<ChooseStudentRole>((event, emit) async {
      _logger.i(
        'ChooseStudentRole event triggered for user: ${event.user.email}',
      );
      emit(Loading());
      try {
        _logger.i('Checking if student exists for email: ${event.user.email}');
        final response = await studentRepository.getStudents({
          "email": event.user.email,
          "limit": "10",
          "offset": "0",
          'extended': 'true',
        });
        _logger.i('StudentRepository.getStudents response: ${response.data}');
        Student? student;
        if (response.data == null) {
          try {
            _logger.i('No student found, creating new student');
            final createStudentResponse = await studentRepository.createStudent(
              {"name": event.user.name, "email": event.user.email},
            );
            _logger.i(
              'StudentRepository.createStudent response: ${createStudentResponse.data}',
            );
            if (createStudentResponse.statusCode! >= 200) {
              student = Student.fromJson(createStudentResponse.data);
            } else {
              _logger.e(
                'Failed to create student: ${createStudentResponse.data}',
              );
              emit(AuthNotSignedIn());
              return;
            }
          } catch (e, s) {
            _logger.e('Error creating student: $e', error: e, stackTrace: s);
            emit(AuthNotSignedIn());
            return;
          }
        } else {
          student = Student.fromJson(response.data[0]);
        }
        try {
          _logger.i('Updating user role to student');
          final updateUserResponse = await userRepository.updateUser(
            event.user.copyWith(role: 'student'),
          );
          _logger.i(
            'UserRepository.updateUser response: ${updateUserResponse.data}',
          );
          if (updateUserResponse.statusCode! >= 200) {
            emit(
              AuthSignedInAsStudent(
                user: event.user.copyWith(role: 'student'),
                student: student,
              ),
            );
            return;
          } else {
            _logger.e('Failed to update user role: ${updateUserResponse.data}');
            emit(AuthNotSignedIn());
            return;
          }
        } catch (e, s) {
          _logger.e('Error choosing student role: $e', error: e, stackTrace: s);
          emit(AuthNotSignedIn());
          return;
        }
      } catch (e, s) {
        _logger.e('Error choosing student role: $e', error: e, stackTrace: s);
        emit(AuthNotSignedIn());
        return;
      }
    });

    on<EmailSignIn>((event, emit) async {
      _logger.i('EmailSignIn event triggered for email: ${event.email}');
      emit(Loading());
      try {
        _logger.i('Attempting email sign in');
        Map<String, dynamic>? response = await emailAuthService.signIn(
          email: event.email,
          password: event.password,
        );
        _logger.i('Email sign in response: "+response.toString()+"');
        if (response == null) {
          _logger.w('Email sign in returned null response');
          emit(AuthNotSignedIn());
          return;
        }
        await _handleUserAuthentication(response, emit);
      } catch (e, s) {
        _logger.e('Email sign in error: $e', error: e, stackTrace: s);
        emit(AuthFailure(e.toString()));
        return;
      }
    });

    on<EmailSignUp>((event, emit) async {
      _logger.i('EmailSignUp event triggered for email: ${event.email}');
      emit(Loading());
      try {
        _logger.i('Attempting email sign up');
        Map<String, dynamic>? response = await emailAuthService.signUp(
          email: event.email,
          password: event.password,
          displayName: event.displayName,
        );
        _logger.i('Email sign up response: "+response.toString()+"');
        if (response == null) {
          _logger.w('Email sign up returned null response');
          emit(AuthNotSignedIn());
          return;
        }
        await _handleUserAuthentication(response, emit);
      } catch (e, s) {
        _logger.e('Email sign up error: $e', error: e, stackTrace: s);
        emit(AuthFailure(e.toString()));
        return;
      }
    });

    on<SendPasswordResetEmail>((event, emit) async {
      _logger.i(
        'SendPasswordResetEmail event triggered for email: ${event.email}',
      );
      try {
        await emailAuthService.sendPasswordResetEmail(email: event.email);
        _logger.i('Password reset email sent to: ${event.email}');
        emit(PasswordResetEmailSent(event.email));
      } catch (e, s) {
        _logger.e('Password reset error: $e', error: e, stackTrace: s);
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignOut>((event, emit) async {
      _logger.i('SignOut event triggered');
      await googleAuthServices.signOut();
      await emailAuthService.signOut();
      _logger.i('User signed out');
      emit(AuthNotSignedIn());
    });
  }

  /// Helper method to handle user authentication logic for both Google and Email auth
  Future<void> _handleUserAuthentication(
    Map<String, dynamic> response,
    Emitter<AuthState> emit,
  ) async {
    _logger.i('_handleUserAuthentication called with response: $response');
    try {
      final checkUserResponse = await userRepository.getAllUsers({
        "email": response['email'],
        "limit": "1",
        "offset": "0",
      });
      _logger.i(
        'UserRepository.getAllUsers response: ${checkUserResponse.data}',
      );
      LumenUser? lumenUser;
      if (checkUserResponse.data == null ||
          (checkUserResponse.data as List).isEmpty) {
        try {
          _logger.i('No user found, creating new user');
          final createUserResponse = await userRepository.createUser({
            "name": response['displayName'] ?? '',
            "email": response['email'] ?? '',
          });
          _logger.i(
            'UserRepository.createUser response: ${createUserResponse.data}',
          );
          if (createUserResponse.statusCode! >= 200 &&
              createUserResponse.data != null) {
            final userData = createUserResponse.data as Map<String, dynamic>;
            userData['photoUrl'] = response['photoUrl'];
            lumenUser = LumenUser.fromJson(userData);
          } else {
            _logger.e('Failed to create user: ${createUserResponse.data}');
            emit(AuthNotSignedIn());
            return;
          }
        } catch (e, s) {
          _logger.e('Error creating user: $e', error: e, stackTrace: s);
          emit(AuthNotSignedIn());
          return;
        }
      } else {
        final userData =
            (checkUserResponse.data as List).first as Map<String, dynamic>;
        userData['photoUrl'] = response['photoUrl'];
        lumenUser = LumenUser.fromJson(userData);
      }
      if (lumenUser == null) {
        _logger.e('Failed to create or retrieve user');
        emit(AuthNotSignedIn());
        return;
      }
      
      if (lumenUser.role == null) {
        _logger.w('User role is null for user: ${lumenUser.id}');
        emit(AuthSignedInAsAnonymous(lumenUser));
        return;
      } else if (lumenUser.role == 'teacher') {
        _logger.i('User is a teacher, checking teacher record');
        final checkTeacherResponse = await teacherRepository.getAllTeachers({
          "email": response['email'],
          "limit": "10",
          "offset": "0",
        });
        _logger.i(
          'TeacherRepository.getAllTeachers response: ${checkTeacherResponse.data}',
        );
        Teacher? teacher;
        if (checkTeacherResponse.data == null ||
            (checkTeacherResponse.data as List).isEmpty) {
          try {
            _logger.i('No teacher found, creating new teacher');
            final createTeacherResponse = await teacherRepository.createTeacher(
              {
                "name": response['displayName'] ?? '',
                "email": response['email'] ?? '',
              },
            );
            _logger.i(
              'TeacherRepository.createTeacher response: ${createTeacherResponse.data}',
            );
            if (createTeacherResponse.statusCode! >= 200 &&
                createTeacherResponse.data != null) {
              teacher = Teacher.fromJson(
                createTeacherResponse.data as Map<String, dynamic>,
              );
            } else {
              _logger.e(
                'Failed to create teacher: ${createTeacherResponse.data}',
              );
              emit(AuthNotSignedIn());
              return;
            }
          } catch (e, s) {
            _logger.e('Error creating teacher: $e', error: e, stackTrace: s);
            emit(AuthNotSignedIn());
            return;
          }
        } else {
          teacher = Teacher.fromJson(
            (checkTeacherResponse.data as List).first as Map<String, dynamic>,
          );
        }
        if (teacher != null) {
          emit(AuthSignedInAsTeacher(user: lumenUser, teacher: teacher));
        } else {
          emit(AuthNotSignedIn());
        }
        return;
      } else if (lumenUser.role == 'student') {
        _logger.i('User is a student, checking student record');
        final checkStudentResponse = await studentRepository.getStudents({
          "email": response['email'],
          "limit": "10",
          "offset": "0",
          'extended': 'true',
        });
        _logger.i(
          'StudentRepository.getStudents response: ${checkStudentResponse.data}',
        );
        Student? student;
        if (checkStudentResponse.data == null ||
            (checkStudentResponse.data as List).isEmpty) {
          try {
            _logger.i('No student found, creating new student');
            final createStudentResponse = await studentRepository.createStudent(
              {
                "name": response['displayName'] ?? '',
                "email": response['email'] ?? '',
              },
            );
            _logger.i(
              'StudentRepository.createStudent response: ${createStudentResponse.data}',
            );
            if (createStudentResponse.statusCode! >= 200 &&
                createStudentResponse.data != null) {
              student = Student.fromJson(
                createStudentResponse.data as Map<String, dynamic>,
              );
            } else {
              _logger.e(
                'Failed to create student: ${createStudentResponse.data}',
              );
              emit(AuthNotSignedIn());
              return;
            }
          } catch (e, s) {
            _logger.e('Error creating student: $e', error: e, stackTrace: s);
            emit(AuthNotSignedIn());
            return;
          }
        } else {
          student = Student.fromJson(
            (checkStudentResponse.data as List).first as Map<String, dynamic>,
          );
        }
        if (student != null) {
          emit(AuthSignedInAsStudent(user: lumenUser, student: student));
        } else {
          emit(AuthNotSignedIn());
        }
        return;
      } else {
        _logger.w('User role is not recognized: ${lumenUser.role}');
        emit(AuthNotSignedIn());
        return;
      }
    } catch (e, s) {
      _logger.e(
        'Error in _handleUserAuthentication: $e',
        error: e,
        stackTrace: s,
      );
      emit(AuthFailure('Authentication failed: ${e.toString()}'));
    }
  }
}
