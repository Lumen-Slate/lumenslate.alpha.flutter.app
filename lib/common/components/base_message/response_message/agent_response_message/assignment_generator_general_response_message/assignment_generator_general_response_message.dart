import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../serializers/agent_serializers/assignment_generator_general_serializer.dart';
import '../agent_response_message.dart';

final class AssignmentGeneratorGeneralResponseMessage extends StatelessWidget implements AgentResponseMessage {
  final AssignmentGeneratorSerializer response;

  const AssignmentGeneratorGeneralResponseMessage({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text(response.title, style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(response.body, style: GoogleFonts.jost(fontSize: 14)),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                _buildCount('MCQ count:', response.mcqCount),
                _buildCount('NAT count:', response.natCount),
                _buildCount('MSQ count:', response.msqCount),
                _buildCount('Subjective count:', response.subjectiveCount),
              ],
            ),
            FilledButton.tonal(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.blue[100],
              ),
              onPressed: () {
                // context.go('/assignments/${response.assignmentId}');
                context.go('/teacher-dashboard/assignments/');
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  Text('Go to Assignments', style: GoogleFonts.jost(fontSize: 14)),
                  Icon(Icons.arrow_forward, size: 16, color: Colors.blue[800]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCount(String label, int count) {
    return Chip(
      elevation: 0,
      backgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent, width: 0),
        borderRadius: BorderRadius.circular(8),
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 10,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(count.toString(), style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
