import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/auth/auth_bloc.dart';

class SignInOptionsMobile extends StatelessWidget {
  const SignInOptionsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sign In',
          style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 32),
        
        // Google Sign In Button
        OutlinedButton(
          onPressed: () {
            context.read<AuthBloc>().add(GoogleSignIn());
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(double.infinity, 48),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/google.svg",
                width: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Google',
                style: GoogleFonts.jost(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(width: 8),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Email Sign In Button
        OutlinedButton(
          onPressed: () {
            context.go('/sign-in/email');
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(double.infinity, 48),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.email,
                size: 24,
                color: Colors.black,
              ),
              const SizedBox(width: 8),
              Text(
                'Email',
                style: GoogleFonts.jost(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
