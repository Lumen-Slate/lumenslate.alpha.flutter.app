import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumen_slate/models/classroom.dart';

class ClassroomTile extends StatelessWidget {
  final Classroom classroom;
  final List<String> teacherNames;
  final List<dynamic> classroomAssignments;
  final int index;

  const ClassroomTile({
    super.key,
    required this.classroom,
    required this.teacherNames,
    required this.classroomAssignments,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return FilledButton.tonal(
      onPressed: () {},
      style: FilledButton.styleFrom(
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0)),
        padding: const EdgeInsets.all(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(classroom.subject, style: GoogleFonts.poppins(fontSize: 46, fontWeight: FontWeight.w600)),
            Text(
              'Teachers: ${teacherNames.join(', ')}',
              style: GoogleFonts.poppins(fontSize: 26, color: Colors.grey[700]),
            ),
            Row(
              spacing: 10,
              children: [
                Text('Assignments', style: GoogleFonts.poppins(fontSize: 20, color: Colors.grey[600])),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
                  child: Center(
                    child: Text(
                      classroomAssignments.length.toString(),
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: classroomAssignments.length,
                  itemBuilder: (context, assignmentIndex) {
                    final assignment = classroomAssignments[assignmentIndex];
                    return FilledButton.tonal(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        padding: const EdgeInsets.all(12.0),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(assignment.title, style: GoogleFonts.poppins(fontSize: 14)),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
