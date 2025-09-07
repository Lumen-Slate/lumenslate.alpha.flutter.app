import 'package:flutter/material.dart';
import 'desktop/profile_page_desktop.dart';
import 'mobile/profile_page_mobile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simple responsive switch
    if (MediaQuery.of(context).size.width > 600) {
      return const ProfilePageDesktop();
    } else {
      return const ProfilePageMobile();
    }
  }
}
