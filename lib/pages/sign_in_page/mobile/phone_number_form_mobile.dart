import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../cubit/phone_form/phone_number_form_cubit.dart';
import '../components/country_code_dropdown.dart';
import '../components/phone_login_unavailable.dart';

class PhoneNumberFormMobile extends StatefulWidget {
  const PhoneNumberFormMobile({super.key});

  @override
  State<PhoneNumberFormMobile> createState() => _PhoneNumberFormMobileState();
}

class _PhoneNumberFormMobileState extends State<PhoneNumberFormMobile> {
  String _selectedCountryCode = '+91';
  final TextEditingController _phoneController = TextEditingController();
  bool _isVerifyButtonEnabled = true;
  Timer? _timer;
  int _start = 120;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void startOtpTimer() {
    setState(() {
      _start = 120;
      _isVerifyButtonEnabled = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          _isVerifyButtonEnabled = false;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.read<PhoneNumberFormCubit>().togglePhoneInput();
                if ((context.read<PhoneNumberFormCubit>().state
                        as PhoneNumberForm)
                    .isOTPSent) {
                  context.read<PhoneNumberFormCubit>().toggleOTPSent();
                }
              },
            ),
          ),
          Text(
            'Phone Sign In',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                BlocBuilder<PhoneNumberFormCubit, PhoneNumberFormState>(
                  builder: (context, state) {
                    final phoneState = state as PhoneNumberForm;
                    return TextFormField(
                      controller: _phoneController,
                      // 'enabled' removed; not required in recent Flutter versions
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        if (value.length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: GoogleFonts.poppins(fontSize: 16),
                        prefixIcon: CountryCodeDropdown(
                          selectedCountryCode: _selectedCountryCode,
                          onChanged: (String? code) {
                            setState(() {
                              _selectedCountryCode = code ?? '+91';
                            });
                          },
                          enabled: true,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<PhoneNumberFormCubit, PhoneNumberFormState>(
                  builder: (context, state) {
                    if ((state as PhoneNumberForm).isOTPSent) {
                      return Column(
                        children: [
                          Pinput(length: 6, onCompleted: (pin) {}),
                          const SizedBox(height: 16),
                          Text(
                            'Resend OTP in $_start s',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<PhoneNumberFormCubit, PhoneNumberFormState>(
                  builder: (context, state) {
                    if ((state as PhoneNumberForm).isOTPSent) {
                      return ElevatedButton(
                        onPressed: _isVerifyButtonEnabled ? () {} : null,
                        child: const Text('Verify OTP'),
                      );
                    }
                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Trigger phone number verification
                        }
                      },
                      child: const Text('Send OTP'),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
