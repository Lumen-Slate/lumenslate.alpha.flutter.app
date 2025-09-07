import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'desktop/teacher_dashboard_desktop.dart';
import 'mobile/teacher_dashboard_mobile.dart';

class TeacherDashboardPage extends StatelessWidget {
  const TeacherDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile) {
          return TeacherDashboardMobile();
        } else {
          return TeacherDashboardDesktop();
        }
      },
    );
  }
}
