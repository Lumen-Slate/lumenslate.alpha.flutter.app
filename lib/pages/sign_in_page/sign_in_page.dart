import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'desktop/sign_in_desktop.dart';
import 'mobile/sign_in.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    if (isMobile) {
      return const SignInPageMobile();
    } else {
      return const SignInDesktop();
    }
  }
}
