part of 'phone_number_form_cubit.dart';

@immutable
sealed class PhoneNumberFormState {}

final class PhoneNumberForm extends PhoneNumberFormState {
  final bool isPhoneInputOpen;
  final bool isOTPSent;

  PhoneNumberForm({this.isPhoneInputOpen = false, this.isOTPSent = false});
}
