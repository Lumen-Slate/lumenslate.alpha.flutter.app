import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumen_slate/models/classroom.dart';
import 'package:go_router/go_router.dart';

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
    return FilledButton.tonal(
      onPressed: () {
        context.go('/teacher-dashboard/classrooms/${classroom.id}/students');
      },
      style: FilledButton.styleFrom(
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0)),
        padding: const EdgeInsets.all(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                classroom.subject,
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Flexible(
              child: Text(
                'Teachers: ${classroom.teacherIds.length}',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              spacing: 6,
              children: [
                Flexible(
                  child: Text(
                    'Assignments',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6.0)),
                  child: Center(
                    child: Text(
                      classroom.assignmentIds.length.toString(),
                      style: GoogleFonts.poppins(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            // Expanded(
            //   child: Container(
            //     padding: const EdgeInsets.all(16.0),
            //     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
            //     child: ListView.separated(
            //       controller: scrollController,
            //       itemCount: classroomAssignments.length,
            //       itemBuilder: (context, assignmentIndex) {
            //         final assignment = classroomAssignments[assignmentIndex];
            //         return FilledButton.tonal(
            //           onPressed: () {},
            //           style: FilledButton.styleFrom(
            //             backgroundColor: Colors.grey[200],
            //             foregroundColor: Colors.black,
            //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            //             padding: const EdgeInsets.all(12.0),
            //           ),
            //           child: Align(
            //             alignment: Alignment.centerLeft,
            //             child: Text(assignment.title, style: GoogleFonts.poppins(fontSize: 14)),
            //           ),
            //         );
            //       },
            //       separatorBuilder: (context, index) => SizedBox(height: 12),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
