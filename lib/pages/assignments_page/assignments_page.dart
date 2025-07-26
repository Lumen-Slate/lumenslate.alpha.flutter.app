import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'desktop/assignments_page_desktop.dart';
import 'mobile/assignments_page_mobile.dart';

class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile) {
          return const AssignmentsPageMobile();
        } else {
          return const AssignmentsPageDesktop();
        }
      },
    );
  }
}
