import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/auth/auth_bloc.dart';

import 'email_sign_in_form.dart';

class SignInOptionsDesktop extends StatefulWidget {
  const SignInOptionsDesktop({super.key});

  @override
  State<SignInOptionsDesktop> createState() => _SignInOptionsDesktopState();
}

class _SignInOptionsDesktopState extends State<SignInOptionsDesktop> {
  bool _showEmailForm = false;

  void _toggleEmailForm() {
    setState(() {
      _showEmailForm = !_showEmailForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 500, // Minimum height to maintain layout
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: _showEmailForm ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                SizedBox(height: _showEmailForm ? 20 : 30),
                Text(
                  'Sign In', // Use localized string
                  style: GoogleFonts.poppins(
                    fontSize: _showEmailForm ? 50 : 70, 
                    fontWeight: FontWeight.w400
                  ),
                ),
                SizedBox(height: _showEmailForm ? 20 : 80),
                
                if (_showEmailForm) ...[
                  // Email Sign In Form
                  const EmailSignInForm(),
                  const SizedBox(height: 30),
                  
                  // Back to options button
                  TextButton(
                    onPressed: _toggleEmailForm,
                    child: Text(
                      'Back to other sign-in options',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ] else ...[
                  // Google Sign In Button
                  OutlinedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(GoogleSignIn());
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      minimumSize: const Size(double.infinity, 80),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/google.svg",
                          width: 35,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Google', // Use localized string
                          style: GoogleFonts.jost(fontSize: 30, color: Colors.black),
                        ),
                        const SizedBox(width: 15),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is Loading) {
                              return const SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Email Sign In Button
                  OutlinedButton(
                    onPressed: _toggleEmailForm,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      minimumSize: const Size(double.infinity, 80),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.email,
                          size: 35,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Email', // Use localized string
                          style: GoogleFonts.jost(fontSize: 30, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
