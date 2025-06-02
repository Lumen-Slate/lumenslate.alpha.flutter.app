import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'phone_number_form_state.dart';

class PhoneNumberFormCubit extends Cubit<PhoneNumberFormState> {
  PhoneNumberFormCubit() : super(PhoneNumberForm());

  void togglePhoneInput() {
    emit(
        PhoneNumberForm(isPhoneInputOpen: !(state as PhoneNumberForm).isPhoneInputOpen, isOTPSent: (state as PhoneNumberForm).isOTPSent));
  }

  void toggleOTPSent() {
    emit(
        PhoneNumberForm(isPhoneInputOpen: (state as PhoneNumberForm).isPhoneInputOpen, isOTPSent: !(state as PhoneNumberForm).isOTPSent));
  }
}
