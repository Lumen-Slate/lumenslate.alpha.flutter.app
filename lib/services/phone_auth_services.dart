import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lumen_slate/services/logging_service.dart';

class PhoneAuth {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  String? phoneNumber;
  late String _verificationId;
  ConfirmationResult? _confirmationResult; // For web

  Future signInOTP(String countryCode, String phoneNumber) async {
    this.phoneNumber = phoneNumber;

    try {
      // Check if the platform is web or mobile (Android/iOS)
      if (!kIsWeb) {
        // Native platforms: Android, iOS
        await _auth.verifyPhoneNumber(
          phoneNumber: countryCode + phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException exception) =>
              LoggingService.warning('Your phone number is not valid. ${exception.message}'),
          codeSent: (String verificationId, int? resendToken) {
            LoggingService.info('OTP sent to ${countryCode + phoneNumber}');
            _verificationId = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            LoggingService.warning('OTP timeout for ${countryCode + phoneNumber}');
          },
          timeout: Duration(
            seconds: 120,
          ), // Adjust the timeout duration as needed
        );
      } else {
        _confirmationResult = await _auth.signInWithPhoneNumber(
          countryCode + phoneNumber,
        );
        LoggingService.info('OTP sent to ${countryCode + phoneNumber}');
      }
    } catch (e) {
      LoggingService.error('Failed to send OTP: $e');
    }
  }

  Future<Map<String, dynamic>?> verifyOTP(String otp) async {
    try {
      if (!kIsWeb) {
        // Native platforms
        final PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: otp,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );

        if (userCredential.user != null) {
          return {'phoneNumber': phoneNumber ?? ''};
        }
      } else {
        // Web platform
        if (_confirmationResult != null) {
          UserCredential userCredential = await _confirmationResult!.confirm(
            otp,
          );
          if (userCredential.user != null) {
            return {'phoneNumber': phoneNumber ?? ''};
          }
        }
      }

      LoggingService.warning('Failed to verify OTP for $phoneNumber');
      return null;
    } catch (e) {
      LoggingService.error('Failed to verify OTP: $e');
      return null;
    }
  }
}
