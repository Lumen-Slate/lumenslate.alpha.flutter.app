import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/assignments.dart';
import '../each_assignment.dart';

class AssignmentTile extends StatelessWidget {
  final Assignments assignment;

  const AssignmentTile({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssignmentDetailPage(assignment: assignment),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                assignment.title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                assignment.body,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.red[400]),
                  const SizedBox(width: 6),
                  Text(
                    "Due: ${assignment.dueDate.toLocal().toString().split(' ')[0]}",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.red[400],
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.star, size: 16, color: Colors.orange[400]),
                  const SizedBox(width: 4),
                  Text(
                    "${assignment.points} pts",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}