part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class Loading extends AuthState {}

class AuthPending extends AuthState {}

class AuthSuccess extends AuthState {
  final String id;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String message;
  final Teacher teacher;

  AuthSuccess({
    required this.id,
    required this.displayName,
    required this.email,
    this.photoUrl,
    required this.message,
    required this.teacher,
  });
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}
