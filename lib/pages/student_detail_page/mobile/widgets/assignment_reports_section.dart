import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/students.dart';
import 'assignment_report_popup.dart';

class AssignmentReportsSectionMobile extends StatelessWidget {
  final Student student;
  final String classroomId;

  const AssignmentReportsSectionMobile({
    super.key,
    required this.student,
    required this.classroomId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              'Assignment Reports',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.orange[800],
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Recent Assignments List
                GestureDetector(
                  onTap: () => _navigateToAssignmentReport(context, 'Physics Assignment #1'),
                  child: _buildAssignmentCard(
                    title: 'Physics Assignment #1',
                    score: '85/100',
                    date: 'Jan 15, 2025',
                    status: 'Completed',
                    statusColor: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => _navigateToAssignmentReport(context, 'Math Quiz #3'),
                  child: _buildAssignmentCard(
                    title: 'Math Quiz #3',
                    score: '92/100',
                    date: 'Jan 12, 2025',
                    status: 'Completed',
                    statusColor: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => _navigateToAssignmentReport(context, 'Chemistry Lab Report'),
                  child: _buildAssignmentCard(
                    title: 'Chemistry Lab Report',
                    score: '78/100',
                    date: 'Jan 10, 2025',
                    status: 'Completed',
                    statusColor: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                _buildAssignmentCard(
                  title: 'Biology Assignment #2',
                  score: '--',
                  date: 'Due: Jan 20, 2025',
                  status: 'Pending',
                  statusColor: Colors.orange,
                ),
                const SizedBox(height: 20),
                // View All Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to detailed assignment history
                    },
                    icon: const Icon(Icons.list_alt, size: 20),
                    label: Text(
                      'View All Assignments',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard({
    required String title,
    required String score,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              if (score != '--')
                Text(
                  'Score: $score',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[600],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToAssignmentReport(BuildContext context, String assignmentTitle) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AssignmentReportPopupMobile(
          student: student,
          classroomId: classroomId,
        ),
      ),
    );
  }
}
