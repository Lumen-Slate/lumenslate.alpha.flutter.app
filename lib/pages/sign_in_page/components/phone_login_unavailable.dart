import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../constants/app_constants.dart';

class PhoneLoginUnavailable extends StatelessWidget {
  const PhoneLoginUnavailable({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: AppConstants.desktopScaleWidth,
      child: Dialog(
        child: SizedBox(
          width: 600,
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Developer's Notice", style: GoogleFonts.poppins(fontSize: 36)),
                  const SizedBox(height: 20),
                  Text(
                    'We regret to inform that we have exhausted our resources for SMS apis that we were using to send OTP via SMS. Please use Google Auth Instead. We apologize for the inconvenience caused',
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
