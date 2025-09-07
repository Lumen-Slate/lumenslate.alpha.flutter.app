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
import '../../services/google_auth_services.dart';
import '../../services/phone_auth_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GoogleAuthService googleAuthService;
  final PhoneAuth phoneAuthServices;
  final TeacherRepository teacherRepository;
  final UserRepository userRepository = UserRepository();
  final StudentRepository studentRepository = StudentRepository();
  final _logger = Logger();
  StreamSubscription<User?>? _userSub;

  AuthBloc({required this.googleAuthServices, required this.phoneAuthServices, required this.teacherRepository})
    : super(AuthInitial()) {
    _userSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        add(SignOut());
      }
    });
  } {
    on<GoogleSignIn>((event, emit) async {
      emit(Loading());
      try {
        Map<String, dynamic>? response = await googleAuthServices.signInGoogle();
        if (response == null) {
          emit(AuthNotSignedIn());
          return;
        }

        final checkUserResponse = await userRepository.getAllUsers({
          "email": response['email'],
          "limit": "1",
          "offset": "0",
        });

        LumenUser? lumenUser;

        if (checkUserResponse.data == null) {
          try {
            final createUserResponse = await userRepository.createUser({
              "name": response['displayName'],
              "email": response['email'],
            });
            if (createUserResponse.statusCode! >= 200) {
              lumenUser = LumenUser.fromJson({...createUserResponse.data, 'photoUrl': response['photoUrl']});
            } else {
              _logger.e('Failed to create user: ${createUserResponse.data}');
              emit(AuthNotSignedIn());
              return;
            }
          } catch (e) {
            _logger.e('Error creating user: $e');
            emit(AuthNotSignedIn());
            return;
          }
        } else {
          lumenUser = LumenUser.fromJson({...checkUserResponse.data[0], 'photoUrl': response['photoUrl']});
        }

        if (lumenUser.role == null) {
          Logger().w('User role is null for user: ${lumenUser.id}');
          emit(AuthSignedInAsAnonymous(lumenUser));
          return;
        } else if (lumenUser.role == 'teacher') {
          final checkTeacherResponse = await teacherRepository.getAllTeachers({
            "email": response['email'],
            "limit": "10",
            "offset": "0",
          });
          Teacher? teacher;

          if (checkTeacherResponse.data == null) {
            try {
              final createTeacherResponse = await teacherRepository.createTeacher({
                "name": response['displayName'],
                "email": response['email'],
              });
              if (createTeacherResponse.statusCode! >= 200) {
                teacher = Teacher.fromJson(createTeacherResponse.data);
              } else {
                _logger.e('Failed to create teacher: ${createTeacherResponse.data}');
                emit(AuthNotSignedIn());
                return;
              }
            } catch (e) {
              _logger.e('Error creating teacher: $e');
              emit(AuthNotSignedIn());
              return;
            }
          } else {
            teacher = Teacher.fromJson(checkTeacherResponse.data[0]);
          }
          emit(AuthSignedInAsTeacher(user: lumenUser, teacher: teacher));
          return;
        } else if (lumenUser.role == 'student') {
          final checkStudentResponse = await studentRepository.getStudents({
            "email": response['email'],
            "limit": "10",
            "offset": "0",
            'extended': 'true',
          });

          Student? student;

          if (checkStudentResponse.data == null) {
            try {
              final createStudentResponse = await studentRepository.createStudent({
                "name": response['displayName'],
                "email": response['email'],
              });
              if (createStudentResponse.statusCode! >= 200) {
                student = Student.fromJson(createStudentResponse.data);
              } else {
                _logger.e('Failed to create student: ${createStudentResponse.data}');
                emit(AuthNotSignedIn());
                return;
              }
            } catch (e) {
              _logger.e('Error creating student: $e');
              emit(AuthNotSignedIn());
              return;
            }
          } else {
            student = Student.fromJson(checkStudentResponse.data[0]);
          }
          emit(AuthSignedInAsStudent(user: lumenUser, student: student));
          return;
        } else {
          emit(AuthNotSignedIn());
          return;
        }
      } catch (e) {
        Logger().e(e);
        emit(AuthNotSignedIn());
        return;
      }
    });

    on<AuthCheck>((event, emit) async {
      final userCompleter = Completer<User?>();

      googleAuthServices.userListener().listen((user) {
        if (user != null && userCompleter.isCompleted == false) {
          userCompleter.complete(user);
        }
      });

      final user = await userCompleter.future.timeout(const Duration(seconds: 2), onTimeout: () => null);

      if (user != null) {
        final checkUserResponse = await userRepository.getAllUsers({"email": user.email!, "limit": "1", "offset": "0"});
        if (checkUserResponse.data == null) {
          emit(AuthNotSignedIn());
          return;
        }
        event.onSuccess?.call();
      } else {
        emit(AuthNotSignedIn());
      }
    });

    on<ChooseTeacherRole>((event, emit) async {
      emit(Loading());
      // check of teacher exists else create
      try {
        final response = await teacherRepository.getAllTeachers({
          "email": event.user.email,
          "limit": "10",
          "offset": "0",
        });
        Teacher? teacher;

        if (response.data == null) {
          try {
            final createTeacherResponse = await teacherRepository.createTeacher({
              "name": event.user.name,
              "email": event.user.email,
            });
            if (createTeacherResponse.statusCode! >= 200) {
              teacher = Teacher.fromJson(createTeacherResponse.data);
            } else {
              _logger.e('Failed to create teacher: ${createTeacherResponse.data}');
              emit(AuthNotSignedIn());
              return;
            }
          } catch (e) {
            _logger.e('Error creating teacher: $e');
            emit(AuthNotSignedIn());
            return;
          }
        } else {
          teacher = Teacher.fromJson(response.data[0]);
        }

        // update the user role to teacher
        try {
          final updateUserResponse = await userRepository.updateUser(event.user.copyWith(role: 'teacher'));
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
        } catch (e) {
          _logger.e('Error choosing teacher role: $e');
          emit(AuthNotSignedIn());
          return;
        }
      } catch (e) {
        _logger.e('Error choosing teacher role: $e');
        emit(AuthNotSignedIn());
        return;
      }
    });

    on<ChooseStudentRole>((event, emit) async {
      emit(Loading());
      // check of student exists else create
      try {
        final response = await studentRepository.getStudents({
          "email": event.user.email,
          "limit": "10",
          "offset": "0",
          'extended': 'true',
        });
        Student? student;

        if (response.data == null) {
          try {
            final createStudentResponse = await studentRepository.createStudent({
              "name": event.user.name,
              "email": event.user.email,
            });
            if (createStudentResponse.statusCode! >= 200) {
              student = Student.fromJson(createStudentResponse.data);
            } else {
              _logger.e('Failed to create student: ${createStudentResponse.data}');
              emit(AuthNotSignedIn());
              return;
            }
          } catch (e) {
            _logger.e('Error creating student: $e');
            emit(AuthNotSignedIn());
            return;
          }
        } else {
          student = Student.fromJson(response.data[0]);
        }

        emit(AuthSignedInAsStudent(user: event.user, student: student));
        return;
      } catch (e) {
        _logger.e('Error choosing student role: $e');
        emit(AuthNotSignedIn());
        return;
      }
    });

    on<SignOut>((event, emit) async {
      await googleAuthServices.signOut();
      emit(AuthNotSignedIn());
    });
  }
}
