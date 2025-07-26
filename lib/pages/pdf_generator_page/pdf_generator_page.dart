import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'desktop/pdf_generator_page_desktop.dart';
import 'mobile/pdf_generator_page_mobile.dart';

class PdfGeneratorPage extends StatelessWidget {
  const PdfGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile) {
          return const PdfGeneratorPageMobile();
        } else {
          return const PdfGeneratorPageDesktop();
        }
      },
    );
  }
}
