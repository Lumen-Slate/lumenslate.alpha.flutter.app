import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lumen_slate/pages/classrooms_page/mobile/widget/classroom_card.dart';

import '../../../blocs/classroom/classroom_bloc.dart';
import '../../../models/classroom.dart';

class ClassroomsPageMobile extends StatefulWidget {
  const ClassroomsPageMobile({super.key});

  @override
  State<ClassroomsPageMobile> createState() => _ClassroomsPageMobileState();
}

class _ClassroomsPageMobileState extends State<ClassroomsPageMobile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int _pageSize = 10;
  final String _teacherId = '0692d515-1621-44ea-85e7-a41335858ee2';

  @override
  void initState() {
    super.initState();
    context.read<ClassroomBloc>().add(InitializeClassroomPaging(extended: false));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClassroomBloc>().add(
        FetchNextClassroomPage(teacherId: _teacherId, pageSize: _pageSize, extended: false),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassroomBloc, ClassroomState>(
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.teal),
                  child: Text('Classrooms',
                      style: GoogleFonts.poppins(fontSize: 24, color: Colors.white)),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Dashboard', style: GoogleFonts.poppins(fontSize: 16)),
                  onTap: () => context.go('/teacher-dashboard'),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text("Your Classrooms", style: GoogleFonts.poppins()),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navigate to classroom creation page
            },
            child: const Icon(Icons.add),
          ),
          body: Builder(
            builder: (_) {
              if (state is ClassroomOriginalSuccess) {
                return PagedListView<int, Classroom>(
                  state: state.pagingState,
                  fetchNextPage: () {
                    context.read<ClassroomBloc>().add(
                      FetchNextClassroomPage(teacherId: _teacherId, pageSize: _pageSize, extended: false),
                    );
                  },
                  builderDelegate: PagedChildBuilderDelegate<Classroom>(
                    itemBuilder: (context, classroom, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: SizedBox(
                        height: 400,
                        child: ClassroomCardMobile(
                          classroom: classroom,
                          teacherNames: const [], // Will be updated when teacher data is available
                          classroomAssignments: const [], // Will be updated when assignment data is available
                          index: index,
                        ),
                      ),
                    ),
                    noItemsFoundIndicatorBuilder: (context) =>
                        const Center(child: Text("No classrooms found.")),
                    firstPageErrorIndicatorBuilder: (context) =>
                        const Center(child: Text("Error loading classrooms")),
                  ),
                );
              }
              if (state is ClassroomFailure) {
                return Center(child: Text('Error loading classrooms'));
              }
              if (state is ClassroomInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
