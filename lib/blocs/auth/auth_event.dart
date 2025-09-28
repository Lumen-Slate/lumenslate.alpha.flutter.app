part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AttemptGoogleSignIn extends AuthEvent {
  final GoogleSignInAccount? account;

  AttemptGoogleSignIn({this.account});
}

class OTPSignIn extends AuthEvent {
  final String countryCode;
  final String phoneNumber;

  OTPSignIn({required this.countryCode, required this.phoneNumber});
}

class ChooseTeacherRole extends AuthEvent {
  final LumenUser user;

  ChooseTeacherRole({required this.user});
}

class ChooseStudentRole extends AuthEvent {
  final LumenUser user;

  ChooseStudentRole({required this.user});
}

class AuthCheck extends AuthEvent {
  final Function()? onSuccess;

  AuthCheck({this.onSuccess});
}

class SignOut extends AuthEvent {}

class OTPVerify extends AuthEvent {
  final String otp;

  OTPVerify({required this.otp});
}

class AttemptEmailSignIn extends AuthEvent {
  final String email;
  final String password;

  AttemptEmailSignIn({required this.email, required this.password});
}

class AttemptEmailSignUp extends AuthEvent {
  final String email;
  final String password;
  final String displayName;

  AttemptEmailSignUp({required this.email, required this.password, required this.displayName});
}

class SendPasswordResetEmail extends AuthEvent {
  final String email;

  SendPasswordResetEmail({required this.email});
}
