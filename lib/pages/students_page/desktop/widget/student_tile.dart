import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:lumen_slate/models/students.dart';

class StudentTile extends StatelessWidget {
  final Student student;
  final int index;
  final String? classroomId;

  const StudentTile({
    super.key,
    required this.student,
    required this.index,
    this.classroomId,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey[100],
      contentPadding: const EdgeInsets.all(12.0),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.primaries[index % Colors.primaries.length][400],
          child: Text(
            student.name.isNotEmpty ? student.name[0].toUpperCase() : 'S',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          student.name,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Roll No: ${student.rollNo}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              student.email,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: student.isActive != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: student.isActive! ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  student.isActive! ? 'Active' : 'Inactive',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: student.isActive! ? Colors.green[800] : Colors.red[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : null,
        onTap: () {
          if (classroomId != null) {
            context.go('/teacher-dashboard/classrooms/$classroomId/students/${student.id}');
          }
        },
    );
  }
}
