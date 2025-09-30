import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConstants {
  static const String appName = 'Lumen Slate';
  static const double desktopScaleWidth = 1960;
  static const double mobileScaleWidth = 450;

  static const bool isDebug = true;

  static String get backendDomain {
    if (isDebug) {
      if (kIsWeb) {
        return 'http://localhost:8080/api/v1';
      } else if (Platform.isAndroid) {
        return 'http://10.0.2.2:8080/api/v1';
      } else {
        return 'http://localhost:8080/api/v1';
      }
    } else {
      return 'http://34.31.238.121/api/v1';
    }
  }

  static const String googleSingInClientId = '287658179545-n2d1dj5t0pgokuk37kob063uk0j76ehm.apps.googleusercontent.com';

  static Duration otpTimeOutDuration = const Duration(minutes: 2);
}
