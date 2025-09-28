import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../blocs/auth/auth_bloc.dart';
import 'desktop/teacher_dashboard_desktop.dart';
import 'mobile/teacher_dashboard_mobile.dart';

class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AuthBloc>().state;
      if (state is! AuthSignedInAsTeacher) {
        context.read<AuthBloc>().add(SignOut());
      }
    });
    super.initState();
  }

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
