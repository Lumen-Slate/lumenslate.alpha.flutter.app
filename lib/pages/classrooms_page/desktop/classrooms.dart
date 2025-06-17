import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumen_slate/pages/classrooms_page/desktop/widget/classroom_tile.dart';
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
              child: GridView.builder(
                itemCount: dummyClassrooms.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 2.0,
                ),
                itemBuilder: (context, index) {
                  final classroom = dummyClassrooms[index];
                  final teacherNames = _getTeacherNames(classroom.teacherIds);
                  final classroomAssignments = dummyAssignments
                      .where((a) => classroom.assignmentIds.contains(a.id))
                      .toList();
                  return ClassroomTile(
                    classroom: classroom,
                    teacherNames: teacherNames,
                    classroomAssignments: classroomAssignments,
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}