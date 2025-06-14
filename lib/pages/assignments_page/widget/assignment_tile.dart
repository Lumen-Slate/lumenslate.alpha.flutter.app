import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/assignments.dart';
import '../each_assignment.dart';

class AssignmentTile extends StatelessWidget {
  final Assignment assignment;

  const AssignmentTile({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssignmentDetailPage(assignmentId: assignment.id),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
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
                      ],
                    ),
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.download, color: Colors.blue),
                  //   onPressed: () => _exportAssignment(context),
                  //   tooltip: 'Export Assignment',
                  // ),
                ],
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

  // Future<void> _exportAssignment(BuildContext context) async {
  //   // Show export options dialog
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Export Assignment', style: GoogleFonts.poppins()),
  //       content: Text('Choose export format:', style: GoogleFonts.poppins()),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             _performExport(context, 'PDF');
  //           },
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Icon(Icons.picture_as_pdf, color: Colors.red),
  //               const SizedBox(width: 8),
  //               Text('PDF', style: GoogleFonts.poppins()),
  //             ],
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             _performExport(context, 'CSV');
  //           },
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Icon(Icons.table_chart, color: Colors.green),
  //               const SizedBox(width: 8),
  //               Text('CSV', style: GoogleFonts.poppins()),
  //             ],
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: Text('Cancel', style: GoogleFonts.poppins()),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Future<void> _performExport(BuildContext context, String format) async {
  //   try {
  //     // Show loading indicator
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => AlertDialog(
  //         content: Row(
  //           children: [
  //             const CircularProgressIndicator(),
  //             const SizedBox(width: 16),
  //             Text('Exporting assignment as $format...', style: GoogleFonts.poppins()),
  //           ],
  //         ),
  //       ),
  //     );
  //
  //     if (format == 'PDF') {
  //       await AssignmentExportService.exportAssignmentPDF(assignment);
  //     } else {
  //       await AssignmentExportService.exportAssignmentCSV(assignment);
  //     }
  //
  //     context.pop(); // Close loading dialog
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Assignment "${assignment.title}" exported as $format successfully!'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } catch (e) {
  //     Navigator.of(context).pop(); // Close loading dialog
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to export assignment: $e'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }
}