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
import '../../services/assignment_export_service.dart';

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
        appBar: AppBar(
          title: Text(assignment.title, style: GoogleFonts.poppins()),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
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
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _exportAssignment(context),
                    icon: const Icon(Icons.download),
                    label: const Text('Export'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
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

  Future<void> _exportAssignment(BuildContext context) async {
    // Show export options dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Assignment', style: GoogleFonts.poppins()),
        content: Text('Choose export format:', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performExport(context, 'PDF');
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.picture_as_pdf, color: Colors.red),
                const SizedBox(width: 8),
                Text('PDF', style: GoogleFonts.poppins()),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performExport(context, 'CSV');
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.table_chart, color: Colors.green),
                const SizedBox(width: 8),
                Text('CSV', style: GoogleFonts.poppins()),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  Future<void> _performExport(BuildContext context, String format) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text('Exporting assignment as $format...', style: GoogleFonts.poppins()),
            ],
          ),
        ),
      );

      if (format == 'PDF') {
        await AssignmentExportService.exportAssignmentPDF(assignment);
      } else {
        await AssignmentExportService.exportAssignmentCSV(assignment);
      }
      
      Navigator.of(context).pop(); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Assignment "${assignment.title}" exported as $format successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to export assignment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
