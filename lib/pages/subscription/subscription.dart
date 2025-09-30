import 'package:flutter/material.dart';
import 'desktop/subscription_desktop.dart';
import 'mobile/subscription_mobile.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 700) {
          // Desktop/tablet layout
          return const SubscriptionDesktop();
        } else {
          // Mobile layout
          return const SubscriptionMobile();
        }
      },
    );
  }
}

