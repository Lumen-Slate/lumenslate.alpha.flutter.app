import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'desktop/question_bank_desktop.dart';
import 'mobile/question_bank_mobile.dart';

class QuestionBankPage extends StatelessWidget {
  const QuestionBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile) {
          return QuestionBankPageMobile();
        } else {
          return QuestionBankPageDesktop();
        }
      },
    );
  }
}
