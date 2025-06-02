import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../constants/app_constants.dart';
import '../desktop/widgets/wide_tile_desktop.dart';

class TeacherDashboardMobile extends StatelessWidget {
  TeacherDashboardMobile({super.key});

  final _fabKey = GlobalKey<ExpandableFabState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPending) {
          context.go('/sign-in');
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.teal),
                child: Text(AppConstants.appName,
                    style: GoogleFonts.poppins(fontSize: 24, color: Colors.white)),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout', style: GoogleFonts.poppins(fontSize: 16)),
                onTap: () {
                  Navigator.pop(context);
                  context.read<AuthBloc>().add(SignOut());
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(AppConstants.appName, style: GoogleFonts.poppins(fontSize: 20)),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          key: _fabKey,
          childrenAnimation: ExpandableFabAnimation.none,
          type: ExpandableFabType.up,
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: Icon(Icons.dashboard, color: Colors.tealAccent.shade700),
            fabSize: ExpandableFabSize.small,
            foregroundColor: Colors.blue,
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
          ),
          closeButtonBuilder: DefaultFloatingActionButtonBuilder(
            child: Icon(Icons.close),
            fabSize: ExpandableFabSize.small,
            foregroundColor: Colors.red,
            backgroundColor: Colors.white,
            shape: CircleBorder(),
          ),
          children: [
            FloatingActionButton.extended(
              heroTag: null,
              label: const Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 10),
                  Text('Add Question'),
                ],
              ),
              onPressed: () => context.go('/add-question'),
            ),
            FloatingActionButton.extended(
              heroTag: null,
              label: const Row(
                children: [
                  Icon(Icons.book_rounded),
                  SizedBox(width: 10),
                  Text('Create Assignment'),
                ],
              ),
              onPressed: () {},
            ),
            FloatingActionButton.extended(
              heroTag: null,
              label: const Row(
                children: [
                  Icon(Icons.business_center_rounded),
                  SizedBox(width: 10),
                  Text('Add Question Bank'),
                ],
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            WideTile(
              title: AutoSizeText("Question Banks", style: GoogleFonts.poppins(fontSize: 30)),
              subTitle: AutoSizeText("Manage your questions banks", style: GoogleFonts.poppins(fontSize: 14)),
              description: AutoSizeText(
                "Questions banks serve as a repository for all of your subjects whether organized by class, subjects, difficulties etc.",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              backgroundColor: Colors.redAccent[100]!,
              onTap: () => context.push('/teacher-dashboard/question-banks'),
            ),
            const SizedBox(height: 20),
            WideTile(
              title: AutoSizeText("Questions", style: GoogleFonts.poppins(fontSize: 30)),
              subTitle: AutoSizeText("Add a new question", style: GoogleFonts.poppins(fontSize: 14)),
              description: AutoSizeText(
                "A special question entry powered by AI to help you create questions faster.",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              backgroundColor: Colors.deepPurpleAccent[100]!,
              onTap: () => context.push('/teacher-dashboard/questions'),
            ),
            const SizedBox(height: 20),
            WideTile(
              title: AutoSizeText("Classrooms", style: GoogleFonts.poppins(fontSize: 30)),
              subTitle: AutoSizeText("Manage classrooms", style: GoogleFonts.poppins(fontSize: 14)),
              description: AutoSizeText(
                "Manage your classrooms, add students, teachers, and assign subjects to them.",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              backgroundColor: Colors.orangeAccent[100]!,
              onTap: () => context.push('/teacher-dashboard/classrooms'),
            ),
            const SizedBox(height: 20),
            WideTile(
              title: AutoSizeText("Assignments", style: GoogleFonts.poppins(fontSize: 30)),
              subTitle: AutoSizeText("Create and export assignments", style: GoogleFonts.poppins(fontSize: 14)),
              description: AutoSizeText(
                "Use AI powered assignment creator to create randomized assignments.",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              backgroundColor: Colors.greenAccent[200]!,
              onTap: () => context.push('/teacher-dashboard/assignments'),
            ),
          ],
        ),
      ),
    );
  }
}
