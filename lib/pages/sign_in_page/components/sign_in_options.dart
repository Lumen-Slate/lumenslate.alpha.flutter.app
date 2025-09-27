import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/auth/auth_bloc.dart';

class SignInOptionsDesktop extends StatelessWidget {
  const SignInOptionsDesktop({super.key});

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Text(
                  'Sign In', // Use localized string
                  style: GoogleFonts.poppins(
                    fontSize: 70,
                    fontWeight: FontWeight.w400
                  ),
                ),
                SizedBox(height: 80),

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
                  onPressed: () {
                    context.go('/sign-in/email');
                  },
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
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
