import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'desktop/rag_agent_page.dart';
import 'mobile/rag_agent_page_mobile.dart';

class RagAgentPage extends StatelessWidget {
  const RagAgentPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile) {
          return const RagAgentPageMobile();
        } else {
          return const RagAgentPageDesktop();
        }
      },
    );
  }
}
