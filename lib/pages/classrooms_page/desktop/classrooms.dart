import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumen_slate/pages/classrooms_page/desktop/widget/classroom_tile.dart';
import '../../../blocs/classroom/classroom_bloc.dart';

class ClassroomsPageDesktop extends StatefulWidget {
  const ClassroomsPageDesktop({super.key});

  @override
  State<ClassroomsPageDesktop> createState() => _ClassroomsPageDesktopState();
}

class _ClassroomsPageDesktopState extends State<ClassroomsPageDesktop> {
  final _scrollController = ScrollController();
  final int _limit = 10;
  final int _offset = 0;
  late String _teacherId;

  @override
  void initState() {
    super.initState();
    _teacherId = "teacherId1";
    context.read<ClassroomBloc>().add(
          LoadClassrooms(
            teacherId: _teacherId,
            limit: _limit,
            offset: _offset,
          ),
        );
  }

  void _fetchClassrooms() {
    context.read<ClassroomBloc>().add(
          LoadClassrooms(
            teacherId: _teacherId,
            limit: _limit,
            offset: _offset,
          ),
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int _getCrossAxisCount(double screenWidth) {
    if (screenWidth >= 1200) {
      return 3;
    } else if (screenWidth >= 800) {
      return 2;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<ClassroomBloc, ClassroomState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: AutoSizeText(
                    "Classrooms",
                    maxLines: 2,
                    minFontSize: 80,
                    style: GoogleFonts.poppins(fontSize: 80),
                  ),
                ),
                const SizedBox(height: 50),
                Expanded(
                  child: Builder(
                    builder: (_) {
                      if (state is ClassroomLoading || state is ClassroomInitial) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ClassroomLoadFailure) {
                        return Center(child: Text(state.error));
                      } else if (state is ClassroomLoadSuccess) {
                        if (state.classrooms.isEmpty) {
                          return const Center(child: Text("No classrooms found."));
                        }
                        return GridView.builder(
                          controller: _scrollController,
                          itemCount:  state.classrooms.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: _getCrossAxisCount(screenWidth),
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: 2.0,
                          ),
                          itemBuilder: (context, index) {
                            if (index >= state.classrooms.length) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final classroom = state.classrooms[index];
                            return ClassroomTile(
                              classroom: classroom,
                              teacherNames: const [],
                              classroomAssignments: const [],
                              index: index,
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
