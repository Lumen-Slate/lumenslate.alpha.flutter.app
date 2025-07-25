import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'desktop/chat_agent_page.dart';
import 'mobile/chat_agent_page.dart';

class ChatAgentPage extends StatelessWidget {
  const ChatAgentPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile) {
          return const ChatAgentPageMobile();
        } else {
          return const ChatAgentPageDesktop();
        }
      },
    );
  }
}
