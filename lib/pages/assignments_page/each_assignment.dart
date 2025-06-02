import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumen_slate/pages/assignments_page/widget/question_tile.dart';
import '../../../../models/comments.dart';
import '../../constants/dummy_data/comments.dart';
import '../../constants/dummy_data/questions/mcq.dart';
import '../../constants/dummy_data/questions/msq.dart';
import '../../constants/dummy_data/questions/nat.dart';
import '../../constants/dummy_data/questions/subjective.dart';
import '../../models/assignments.dart';

class AssignmentDetailPage extends StatelessWidget {
  final Assignments assignment;

  const AssignmentDetailPage({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    final mcqs = dummyMCQs
        .where((q) => (assignment.mcqIds ?? []).contains(q.id))
        .toList();
    final msqs = dummyMSQs
        .where((q) => (assignment.msqIds ?? []).contains(q.id))
        .toList();
    final nats = dummyNATs
        .where((q) => (assignment.natIds ?? []).contains(q.id))
        .toList();
    final subjectives = dummySubjectives
        .where((q) => (assignment.subjectiveIds ?? []).contains(q.id))
        .toList();

    return Scaffold(
        appBar:
            AppBar(title: Text(assignment.title, style: GoogleFonts.poppins())),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(assignment.title,
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(assignment.body, style: GoogleFonts.poppins()),
              const SizedBox(height: 16),
              Text(
                  "Due: ${assignment.dueDate.toLocal().toString().split(' ')[0]}",
                  style: GoogleFonts.poppins(color: Colors.red[400])),
              const SizedBox(height: 24),
              if (mcqs.isNotEmpty)
                buildQuestionSection(
                  title: "Multiple Choice Questions",
                  description:
                      "Choose the correct option. Only one answer is correct.",
                  backgroundColor: Colors.blue,
                  children: mcqs
                      .map((q) => QuestionTile(
                            question: q.question,
                            options: q.options,
                            points: q.points,
                          ))
                      .toList(),
                ),
              if (msqs.isNotEmpty)
                buildQuestionSection(
                  title: "Multiple Select Questions",
                  description:
                      "Select all correct options. More than one may apply.",
                  backgroundColor: Colors.green,
                  children: msqs
                      .map((q) => QuestionTile(
                            question: q.question,
                            options: q.options,
                            points: q.points,
                          ))
                      .toList(),
                ),
              if (nats.isNotEmpty)
                buildQuestionSection(
                  title: "Numerical Answer Type",
                  description: "Type the numerical answer without options.",
                  backgroundColor: Colors.orange,
                  children: nats
                      .map((q) => QuestionTile(
                            question: q.question,
                            points: q.points,
                          ))
                      .toList(),
                ),
              if (subjectives.isNotEmpty)
                buildQuestionSection(
                  title: "Subjective Questions",
                  description: "Write descriptive answers in your own words.",
                  backgroundColor: Colors.purple,
                  children: subjectives
                      .map((q) => QuestionTile(
                            question: q.question,
                            points: q.points,
                          ))
                      .toList(),
                ),

              /// Comments Section
              if ((assignment.commentIds).isNotEmpty)
                buildQuestionSection(
                  title: "Comments",
                  description:
                      "Remarks or feedback related to this assignment.",
                  backgroundColor: Colors.grey,
                  isLast: true,
                  children: assignment.commentIds.map((id) {
                    final comment = dummyComments.firstWhere(
                      (c) => c.id == id,
                      orElse: () => Comments(id: '', commentBody: ''),
                    );

                    if (comment.commentBody.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            child: Icon(Icons.person, size: 16),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              comment.commentBody,
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ));
  }
}

Widget buildQuestionSection({
  required String title,
  required String description,
  required List<Widget> children,
  required Color backgroundColor,
  bool isLast = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 24),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
      const SizedBox(height: 12),
      if (!isLast) const Divider(thickness: 1.2, color: Colors.grey),
    ],
  );
}
