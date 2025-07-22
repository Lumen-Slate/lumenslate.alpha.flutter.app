import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'desktop/students.dart';
import 'mobile/students.dart';

class StudentsPage extends StatelessWidget {
  final String classroomId;

  const StudentsPage({super.key, required this.classroomId});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile) {
          return StudentsPageMobile(classroomId: classroomId);
        } else {
          return StudentsPageDesktop(classroomId: classroomId);
        }
      },
    );
  }
}
