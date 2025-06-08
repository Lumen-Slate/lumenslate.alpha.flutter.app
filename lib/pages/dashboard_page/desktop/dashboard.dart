import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../../constants/app_constants.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../mobile/widgets/wide_tile_mobile.dart';

class TeacherDashboardDesktop extends StatelessWidget {
  TeacherDashboardDesktop({super.key});

  final _fabKey = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPending) {
          context.go('/sign-in');
        }
      },
      child: PopScope(
        onPopInvokedWithResult: (_, __) {
          context.go('/teacher-dashboard');
        },
        child: ResponsiveScaledBox(
          width: 1920,
          child: Scaffold(
            floatingActionButtonLocation: ExpandableFab.location,
            floatingActionButton: Container(
              margin: const EdgeInsets.only(bottom: 20, right: 28),
              child: ExpandableFab(
                key: _fabKey,
                childrenAnimation: ExpandableFabAnimation.none,
                type: ExpandableFabType.up,
                openButtonBuilder: RotateFloatingActionButtonBuilder(
                  child: Icon(Icons.dashboard, color: Colors.tealAccent.shade700),
                  fabSize: ExpandableFabSize.regular,
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.white,
                  shape: CircleBorder(),
                ),
                closeButtonBuilder: DefaultFloatingActionButtonBuilder(
                  child: const Icon(Icons.close),
                  fabSize: ExpandableFabSize.small,
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.white,
                  shape: CircleBorder(),
                ),
                children: [
                  FloatingActionButton.extended(
                    heroTag: null,
                    label: Row(
                      children: [
                        const Icon(Icons.add),
                        const SizedBox(width: 10),
                        Text('Add Question', style: GoogleFonts.jost(fontSize: 18)),
                      ],
                    ),
                    onPressed: () => context.go('/add-question'),
                  ),
                  FloatingActionButton.extended(
                    heroTag: null,
                    label: Row(
                      children: [
                        const Icon(Icons.book_rounded),
                        const SizedBox(width: 10),
                        Text('Create Assignment', style: GoogleFonts.jost(fontSize: 18)),
                      ],
                    ),
                    onPressed: () {},
                  ),
                  FloatingActionButton.extended(
                    heroTag: null,
                    label: Row(
                      children: [
                        const Icon(Icons.business_center_rounded),
                        const SizedBox(width: 10),
                        Text('Add Question Bank', style: GoogleFonts.jost(fontSize: 18)),
                      ],
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
                child: Column(
                  children: [
                    Row(
                      spacing: 20,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: AutoSizeText(
                            AppConstants.appName,
                            maxLines: 2,
                            minFontSize: 80,
                            style: GoogleFonts.poppins(
                              fontSize: 80,
                            ),
                          ),
                        ),
                        Spacer(),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthSuccess && state.photoUrl != null) {
                              return CircleAvatar(
                                radius: 30,
                                child: ClipOval(child: Image.network(state.photoUrl ?? '')),
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                        SizedBox(
                          width: 200,
                          height: 60,
                          child: FilledButton.tonal(
                            onPressed: () {
                              context.read<AuthBloc>().add(SignOut());
                            },
                            child: Text('Logout', style: GoogleFonts.poppins(fontSize: 24)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.push('/teacher-dashboard/question-banks');
                                },
                                child: WideTile(
                                  title: AutoSizeText(
                                    "Question Banks",
                                    style: GoogleFonts.poppins(fontSize: 46),
                                  ),
                                  subTitle: AutoSizeText(
                                    "Manage your questions banks",
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                  description: AutoSizeText(
                                    "Questions banks serve as a repository for all of your subjects whether organized by class, subjects, difficulties etc.",
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                  backgroundColor: Colors.redAccent[100]!,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push('/teacher-dashboard/questions'),
                                child: WideTile(
                                  title: AutoSizeText(
                                    "Questions",
                                    style: GoogleFonts.poppins(
                                      fontSize: 46,
                                    ),
                                  ),
                                  subTitle: AutoSizeText(
                                    "Add a new question",
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                  description: AutoSizeText(
                                    "A special question entry powered by AI to help you create questions faster.",
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                  backgroundColor: Colors.deepPurpleAccent[100]!,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () => context.push('/teacher-dashboard/classrooms'),
                                child: WideTile(
                                  title: AutoSizeText(
                                    "Classrooms",
                                    style: GoogleFonts.poppins(
                                      fontSize: 46,
                                    ),
                                  ),
                                  subTitle: AutoSizeText(
                                    "Manage classrooms",
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                  description: AutoSizeText(
                                    "Manager your classrooms, add students, teachers, and assign subjects to them.",
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                  backgroundColor: Colors.orangeAccent[100]!,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push('/teacher-dashboard/assignments'),
                                child: WideTile(
                                  title: AutoSizeText(
                                    "Assignments",
                                    style: GoogleFonts.poppins(
                                      fontSize: 46,
                                    ),
                                  ),
                                  subTitle: AutoSizeText(
                                    "Create and export assignments",
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                  description: AutoSizeText(
                                    "Use AI powered assignment creator to create randomized assignments.",
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                  backgroundColor: Colors.greenAccent[200]!,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => context.push('/teacher-dashboard/pdf-generator'),
                                child: WideTile(
                                  title: AutoSizeText(
                                    "PDF Generator",
                                    style: GoogleFonts.poppins(
                                      fontSize: 46,
                                    ),
                                  ),
                                  subTitle: AutoSizeText(
                                    "Generate question paper PDFs",
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                  description: AutoSizeText(
                                    "Create professional question papers in PDF format with various question types and subjects.",
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                  backgroundColor: Colors.blueAccent[100]!,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
