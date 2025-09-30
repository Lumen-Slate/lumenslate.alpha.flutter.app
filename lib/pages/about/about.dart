import 'package:flutter/material.dart';
import 'mobile/about_mobile.dart';
import 'desktop/about_desktop.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return const AboutMobilePage();
        } else {
          return const AboutDesktopPage();
        }
      },
    );
  }
}

