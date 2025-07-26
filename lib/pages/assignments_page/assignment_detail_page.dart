import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'desktop/assignment_detail_page_desktop.dart';
import 'mobile/assignment_detail_page_mobile.dart';

class AssignmentDetailPage extends StatelessWidget {
  final String assignmentId;

  const AssignmentDetailPage({super.key, required this.assignmentId});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile) {
          return AssignmentDetailPageMobile(assignmentId: assignmentId);
        } else {
          return AssignmentDetailPageDesktop(assignmentId: assignmentId);
        }
      },
    );
  }
}
