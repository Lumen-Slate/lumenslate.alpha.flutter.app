import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../models/teacher.dart';
import '../../repositories/teacher_repository.dart';
import '../../services/google_auth_services.dart';
import '../../services/phone_auth_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GoogleAuth googleAuthServices;
  final PhoneAuth phoneAuthServices;
  final TeacherRepository teacherRepository;
  final _logger = Logger();

  AuthBloc({required this.googleAuthServices, required this.phoneAuthServices, required this.teacherRepository})
    : super(AuthInitial()) {
    on<GoogleSignIn>((event, emit) async {
      emit(Loading());
      try {
        Map<String, dynamic>? response = await googleAuthServices.signInGoogle();
        if (response == null) {
          emit(AuthPending());
          return;
        }

        final checkTeacherResponse = await teacherRepository.getAllTeachers({
          "email": response['email'],
          "limit": "10",
          "offset": "0",
        });

        Teacher? teacher;

        if (checkTeacherResponse.data == null) {
          try {
            final createTeacherResponse = await teacherRepository.createTeacher(
              // Teacher(id: response['id'], name: response['displayName'], email: response['email']),
              {"name": response['displayName'], "email": response['email']},
            );
            if (createTeacherResponse.statusCode! >= 200) {
              teacher = Teacher.fromJson(createTeacherResponse.data);
            } else {
              _logger.e('Failed to create teacher: ${createTeacherResponse.data}');
            }
          } catch (e) {
            _logger.e('Error creating teacher: $e');
          }
        } else {
          teacher = Teacher.fromJson(checkTeacherResponse.data[0]);
        }

        if (teacher == null) {
          throw Exception('Failed to fetch teacher');
        }

        emit(
          AuthSuccess(
            id: response['id'],
            displayName: response['displayName'],
            email: response['email'],
            photoUrl: response['photoUrl'],
            message: 'User is logged in. ${response['displayName']}',
            teacher: teacher,
          ),
        );
      } catch (e) {
        Logger().e(e);
        emit(AuthPending());
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
        final checkTeacherResponse = await teacherRepository.getAllTeachers({
          "email": user.email!,
          "limit": "10",
          "offset": "0",
        });
        Teacher? teacher;

        if (checkTeacherResponse.data == null) {
          emit(AuthPending());
        } else {
          teacher = Teacher.fromJson(checkTeacherResponse.data[0]);
        }

        if (teacher == null) {
          throw Exception('Failed to fetch teacher');
        }

        emit(
          AuthSuccess(
            id: user.uid,
            displayName: user.displayName ?? '',
            email: user.email ?? '',
            photoUrl: user.photoURL,
            message: 'User is logged in. ${user.displayName}',
            teacher: teacher,
          ),
        );
        event.onSuccess?.call();
      } else {
        emit(AuthPending());
      }
    });

    // on<OTPSignIn>((event, emit) {
    //   emit(Loading());
    //   try {
    //     final response = phoneAuthServices.signInOTP(event.countryCode, event.phoneNumber);
    //     _logger.i(response);
    //     emit(AuthSuccess(id: '', displayName: '', email: '', message: 'OTP sent to ${event.phoneNumber}'));
    //   } catch (e) {
    //     emit(AuthFailure(e.toString()));
    //   }
    // });
    //
    // on<OTPVerify>((event, emit) {
    //   emit(Loading());
    //   try {
    //     final response = phoneAuthServices.verifyOTP(event.otp);
    //     _logger.i(response);
    //     emit(AuthSuccess(id: '', displayName: '', email: '', message: 'OTP verified'));
    //   } catch (e) {
    //     emit(AuthFailure(e.toString()));
    //   }
    // });

    on<SignOut>((event, emit) async {
      await googleAuthServices.signOut();
      emit(AuthPending());
    });
  }
}
