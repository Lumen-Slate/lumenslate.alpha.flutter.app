import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'desktop/questions.dart';
import 'mobile/questions.dart';

class Questions extends StatelessWidget {

  final String? bankId;

  const Questions({super.key, this.bankId});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile) {
          return QuestionsMobile();
        } else {
          return QuestionsDesktop(bankId: bankId);
        }
      },
    );
  }
}
