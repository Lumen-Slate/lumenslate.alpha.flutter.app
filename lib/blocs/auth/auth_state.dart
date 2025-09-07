part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class Loading extends AuthState {}

class AuthNotSignedIn extends AuthState {}

class AuthSignedInAsAnonymous extends AuthState {
  final LumenUser user;

  AuthSignedInAsAnonymous(this.user);
}

class AuthSignedInAsTeacher extends AuthState {
  final LumenUser user;
  final Teacher teacher;

  AuthSignedInAsTeacher({required this.user, required this.teacher});
}

class AuthSignedInAsStudent extends AuthState {
  final LumenUser user;
  final Student student;

  AuthSignedInAsStudent({required this.user, required this.student});
}

// class AuthSuccess extends AuthState {
//   final String id;
//   final String displayName;
//   final String email;
//   final String? photoUrl;
//   final String message;
//   final Teacher teacher;
//
//   AuthSuccess({
//     required this.id,
//     required this.displayName,
//     required this.email,
//     this.photoUrl,
//     required this.message,
//     required this.teacher,
//   });
// }

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}
