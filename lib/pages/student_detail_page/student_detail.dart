import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'desktop/student_detail.dart';
import 'mobile/student_detail.dart';

class StudentDetailPage extends StatelessWidget {
  final String studentId;
  final String classroomId;

  const StudentDetailPage({
    super.key,
    required this.studentId,
    required this.classroomId,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile) {
          return StudentDetailPageMobile(
            studentId: studentId,
            classroomId: classroomId,
          );
        } else {
          return StudentDetailPageDesktop(
            studentId: studentId,
            classroomId: classroomId,
          );
        }
      },
    );
  }
}
