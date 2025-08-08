import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../blocs/auth/auth_bloc.dart';
import '../../../constants/app_constants.dart';
import '../../../cubit/phone_form/phone_number_form_cubit.dart';
import 'phone_number_form_mobile.dart';
import 'sign_in_options_mobile.dart';

class SignInPageMobile extends StatelessWidget {
  const SignInPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go('/teacher-dashboard');
        }
      },
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [Color(0xFFE0F7FA), Color(0xFFFFFFFF)],
          //   ),
          // ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: media.size.width < 400 ? 8 : 24,
                  vertical: 32,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- Logo and App Name ---
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Column(
                        children: [
                          // If you have a logo asset, uncomment below:
                          Image.asset('assets/lumenslate_no_background_616x616.png', width: 100, height: 100),
                          // Icon(Icons.flash_on, color: Colors.teal, size: 72),
                          const SizedBox(height: 12),
                          Text(
                            AppConstants.appName,
                            style: GoogleFonts.jost(
                              fontSize: 44,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // --- Card for Sign In ---
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 420,
                          minWidth: 0,
                        ),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 32,
                              horizontal: 32,
                            ),
                            child:
                                BlocBuilder<
                                  PhoneNumberFormCubit,
                                  PhoneNumberFormState
                                >(
                                  builder: (context, state) {
                                    return (state as PhoneNumberForm)
                                            .isPhoneInputOpen
                                        ? const PhoneNumberFormMobile()
                                        : const SignInOptionsMobile();
                                  },
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    // Divider(
                    //   color: Colors.grey[300],
                    //   thickness: 1.2,
                    //   indent: 60,
                    //   endIndent: 60,
                    // ),
                    // const SizedBox(height: 24),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 8),
                    //   child: const TermsAndPrivacyText(),
                    // ),
                    // const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// --- Terms and Privacy Text Widget ---


class TermsAndPrivacyText extends StatelessWidget {
  const TermsAndPrivacyText({super.key});

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (kIsWeb) {
      // On web, use launchUrlString without mode
      await launchUrlString(url);
    } else {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[700],
          height: 1.5,
        ),
        children: [
          const TextSpan(text: 'By signing in, you agree to our '),
          TextSpan(
            text: 'Terms of Service',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.teal,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchUrl('https://yourdomain.com/terms'),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.teal,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchUrl('https://yourdomain.com/privacy'),
          ),
        ],
      ),
    );
  }
}
