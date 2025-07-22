import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:lumen_slate/pages/classrooms_page/mobile/widget/classroom_card.dart';

import '../../../constants/dummy_data/classroom.dart';
import '../../../constants/dummy_data/assignments.dart';
import '../../../constants/dummy_data/teacher.dart';

class ClassroomsPageMobile extends StatefulWidget {
  const ClassroomsPageMobile({super.key});

  @override
  State<ClassroomsPageMobile> createState() => _ClassroomsPageMobileState();
}

class _ClassroomsPageMobileState extends State<ClassroomsPageMobile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> _getTeacherNames(List<String> teacherIds) {
    return teacherIds
        .map((id) => dummyTeachers.where((t) => t.id == id).toList().firstOrNull)
        .where((teacher) => teacher != null && teacher.name.isNotEmpty)
        .map((teacher) => teacher!.name)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // Using dummy data, so no BLoC calls needed
  }

  @override
  Widget build(BuildContext context) {
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
              onTap: () => context.go('/teacher-dashboard_page'),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: dummyClassrooms.length,
        itemBuilder: (context, index) {
          final classroom = dummyClassrooms[index];
          // Get assignments for this classroom
          final classroomAssignments = dummyAssignments
              .where((assignment) => classroom.assignmentIds.contains(assignment.id))
              .toList();
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SizedBox(
              height: 400,
              child: ClassroomCardMobile(
                classroom: classroom,
                teacherNames: _getTeacherNames(classroom.teacherIds),
                classroomAssignments: classroomAssignments,
                index: index,
              ),
            ),
          );
        },
      ),
    );
  }
}

extension FirstOrNullExtension<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
