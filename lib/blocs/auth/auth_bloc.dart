import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import '../../lib.dart';
import '../../models/teacher.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GoogleAuthService googleAuthService;
  final PhoneAuth phoneAuthServices;
  final TeacherRepository teacherRepository;
  final _logger = Logger();
  StreamSubscription<User?>? _userSub;

  AuthBloc({
    required this.googleAuthService,
    required this.phoneAuthServices,
    required this.teacherRepository,
  }) : super(AuthInitial()) {
    on<AuthCheck>(_onAuthCheck);
    on<GoogleSignIn>(_onGoogleSignIn);
    on<SignOut>(_onSignOut);

    // Firebase auth state listener
    _userSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        add(SignOut());
      }
    });
  }

  Future<void> _onGoogleSignIn(
    GoogleSignIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(Loading());
    try {
      final response = await googleAuthService.signIn();
      if (response == null) {
        emit(AuthPending());
        return;
      }

      final email = response['email'];
      final checkTeacherResponse = await teacherRepository.getAllTeachers({
        "email": email,
        "limit": "10",
        "offset": "0",
      });

      Teacher? teacher;

      if (checkTeacherResponse.data == null ||
          checkTeacherResponse.data.isEmpty) {
        try {
          final createTeacherResponse = await teacherRepository.createTeacher({
            "name": response['displayName'],
            "email": email,
          });
          if (createTeacherResponse.statusCode! >= 200) {
            teacher = Teacher.fromJson(createTeacherResponse.data);
          } else {
            _logger.e(
              'Failed to create teacher: ${createTeacherResponse.data}',
            );
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
          email: email,
          photoUrl: response['photoUrl'],
          message: 'User is logged in. ${response['displayName']}',
          teacher: teacher,
        ),
      );
    } catch (e) {
      _logger.e(e);
      emit(AuthPending());
    }
  }

  Future<void> _onAuthCheck(AuthCheck event, Emitter<AuthState> emit) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final checkTeacherResponse = await teacherRepository.getAllTeachers({
        "email": user.email!,
        "limit": "10",
        "offset": "0",
      });

      Teacher? teacher;
      if (checkTeacherResponse.data == null ||
          checkTeacherResponse.data.isEmpty) {
        emit(AuthPending());
        return;
      } else {
        teacher = Teacher.fromJson(checkTeacherResponse.data[0]);
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
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    await googleAuthService.signOut();
    emit(AuthPending());
  }

  @override
  Future<void> close() {
    _userSub?.cancel();
    return super.close();
  }
}
