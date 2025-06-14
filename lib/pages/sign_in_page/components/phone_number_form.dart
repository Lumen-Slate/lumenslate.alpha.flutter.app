import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:pinput/pinput.dart';

import '../../../cubit/phone_form/phone_number_form_cubit.dart';
import 'country_code_dropdown.dart';
import 'phone_login_unavailable.dart';

class PhoneNumberFormDesktop extends StatefulWidget {
  const PhoneNumberFormDesktop({super.key});

  @override
  State<PhoneNumberFormDesktop> createState() => _PhoneNumberFormDesktopState();
}

class _PhoneNumberFormDesktopState extends State<PhoneNumberFormDesktop> {
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
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.read<PhoneNumberFormCubit>().togglePhoneInput();
                if ((context.read<PhoneNumberFormCubit>().state as PhoneNumberForm).isOTPSent) {
                  context.read<PhoneNumberFormCubit>().toggleOTPSent();
                }
              },
            ),
          ),
          Text('Phone Sign In', style: GoogleFonts.poppins(fontSize: 46, fontWeight: FontWeight.w400)),
          const SizedBox(height: 50),
          Form(
            key: _formKey,
            child: Column(
              children: [
                BlocBuilder<PhoneNumberFormCubit, PhoneNumberFormState>(
                  builder: (context, state) {
                    return TextFormField(
                      controller: _phoneController,
                      enabled: !(state as PhoneNumberForm).isOTPSent,
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
                        labelStyle: GoogleFonts.poppins(fontSize: 20),
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        constraints: const BoxConstraints(maxWidth: 400),
                        contentPadding: const EdgeInsets.symmetric(vertical: 20),
                        prefixIcon: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: CountryCodeDropdown(
                              enabled: false,
                              selectedCountryCode: _selectedCountryCode,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCountryCode = value!;
                                });
                              }),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          BlocBuilder<PhoneNumberFormCubit, PhoneNumberFormState>(
            builder: (context, state) {
              return Column(
                children: [
                  if (!(state as PhoneNumberForm).isOTPSent)
                    FilledButton.tonal(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showDialog(context: context, builder: (context) => const PhoneLoginUnavailable());
                          // context.read<PhoneFormCubit>().toggleOTPSent();
                          // _timer?.cancel();
                          // startOtpTimer();
                        }
                      },
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(const Size(100, 50)),
                      ),
                      child: Text('Send OTP', style: GoogleFonts.poppins(fontSize: 20)),
                    ),
                  if (state.isOTPSent) ...[
                    const SizedBox(height: 20),
                    Text('Please enter the OTP sent to your phone', style: GoogleFonts.poppins(fontSize: 22)),
                    const SizedBox(height: 10),
                    Text('OTP will expire in ${_isVerifyButtonEnabled ? _start : 0} seconds',
                        style: GoogleFonts.poppins(fontSize: 16)),
                    const SizedBox(height: 40),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      child: Pinput(
                        onCompleted: (pin) => Logger().i('OTP entered: $pin'),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton.tonal(
                          onPressed: () {
                            _timer?.cancel();
                            startOtpTimer();
                          },
                          style: ButtonStyle(
                            minimumSize: WidgetStateProperty.all(const Size(100, 50)),
                          ),
                          child: Text('Resend OTP', style: GoogleFonts.poppins(fontSize: 20)),
                        ),
                        const SizedBox(width: 40),
                        FilledButton.tonal(
                          onPressed: _isVerifyButtonEnabled ? () {} : null,
                          style: ButtonStyle(
                            minimumSize: WidgetStateProperty.all(const Size(100, 50)),
                          ),
                          child: Text(
                            'Verify OTP',
                            style: GoogleFonts.poppins(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
