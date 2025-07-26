import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../models/assignments.dart';

class AssignmentTileDesktop extends StatelessWidget {
  final Assignment assignment;

  const AssignmentTileDesktop({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: FilledButton.tonal(
        onPressed: () {
          context.go('/teacher-dashboard/assignments/${assignment.id}');
        },
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assignment.title,
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          assignment.body,
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  // Action buttons could go here in future
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.red[400]),
                  const SizedBox(width: 6),
                  Text(
                    "Due: ${DateFormat('dd-MM-yyyy').format(assignment.dueDate)}",
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.red[400]),
                  ),
                  const Spacer(),
                  Icon(Icons.star, size: 16, color: Colors.orange[400]),
                  const SizedBox(width: 4),
                  Text(
                    "${assignment.points} pts",
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
