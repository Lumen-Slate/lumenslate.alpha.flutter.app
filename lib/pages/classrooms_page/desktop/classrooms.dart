import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumen_slate/pages/classrooms_page/desktop/widget/classroom_card.dart';
import '../../../../../constants/dummy_data/classroom.dart';
import '../../../../../constants/dummy_data/teacher.dart';
import '../../../constants/dummy_data/assignments.dart';

class ClassroomsPageDesktop extends StatelessWidget {
  const ClassroomsPageDesktop({super.key});

  List<String> _getTeacherNames(List<String> teacherIds) {
    return teacherIds
        .map((id) => dummyTeachers.where((t) => t.id == id).toList().firstOrNull)
        .where((teacher) => teacher != null && teacher.name.isNotEmpty)
        .map((teacher) => teacher!.name)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    if (screenWidth >= 1200) {
      crossAxisCount = 3;
    } else if (screenWidth >= 800) {
      crossAxisCount = 2;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Classrooms", style: GoogleFonts.poppins()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          itemCount: dummyClassrooms.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.5,
          ),
          itemBuilder: (context, index) {
            final classroom = dummyClassrooms[index];
            final teacherNames = _getTeacherNames(classroom.teacherIds);
            final classroomAssignments = dummyAssignments
                .where((a) => classroom.assignmentIds.contains(a.id))
                .toList();
            return ClassroomCard(
              classroom: classroom,
              teacherNames: teacherNames,
              classroomAssignments: classroomAssignments,
              index: index,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Future: Add new classroom
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

extension FirstOrNullExtension<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
}