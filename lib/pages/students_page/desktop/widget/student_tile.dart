import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumen_slate/models/students.dart';

class StudentTile extends StatelessWidget {
  final Student student;
  final int index;

  const StudentTile({
    super.key,
    required this.student,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () {
        // TODO: Navigate to student detail page if needed
      },
      style: FilledButton.styleFrom(
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
        padding: const EdgeInsets.all(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.primaries[index % Colors.primaries.length][400],
                  child: Text(
                    student.name.isNotEmpty ? student.name[0].toUpperCase() : 'S',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Roll No: ${student.rollNo}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              student.email,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (student.isActive != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: student.isActive! ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  student.isActive! ? 'Active' : 'Inactive',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: student.isActive! ? Colors.green[800] : Colors.red[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
