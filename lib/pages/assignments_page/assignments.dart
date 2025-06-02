import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumen_slate/pages/assignments_page/widget/assignment_tile.dart';

import '../../constants/dummy_data/assignments.dart';

class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments', style: GoogleFonts.poppins()),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyAssignments.length,
        itemBuilder: (context, index) {
          final assignment = dummyAssignments[index];
          return AssignmentTile(assignment: assignment);
        },
      ),
    );
  }
}
