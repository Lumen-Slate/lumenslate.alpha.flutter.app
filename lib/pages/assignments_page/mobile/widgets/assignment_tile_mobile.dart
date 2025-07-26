import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../models/assignments.dart';

class AssignmentTileMobile extends StatelessWidget {
  final Assignment assignment;

  const AssignmentTileMobile({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    final dueDate = DateFormat('MMM dd, yyyy').format(assignment.dueDate);
    final isOverdue = assignment.dueDate.isBefore(DateTime.now());
    final isDueSoon = assignment.dueDate.difference(DateTime.now()).inDays <= 3 && !isOverdue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.1),
        child: InkWell(
          onTap: () {
            context.go('/teacher-dashboard/assignments/${assignment.id}');
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
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
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            assignment.body,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Status Indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getStatusText(),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Bottom Row with Details
                Row(
                  children: [
                    // Due Date
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: isOverdue ? Colors.red[600] : (isDueSoon ? Colors.orange[600] : Colors.grey[500]),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Due $dueDate',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isOverdue ? Colors.red[600] : (isDueSoon ? Colors.orange[600] : Colors.grey[600]),
                            fontWeight: isOverdue || isDueSoon ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Points
                    Row(
                      children: [
                        Icon(
                          Icons.stars,
                          size: 16,
                          color: Colors.amber[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${assignment.points} pts',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Arrow Icon
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    final now = DateTime.now();
    final daysUntilDue = assignment.dueDate.difference(now).inDays;
    
    if (assignment.dueDate.isBefore(now)) {
      return Colors.red[600]!;
    } else if (daysUntilDue <= 3) {
      return Colors.orange[600]!;
    } else {
      return Colors.green[600]!;
    }
  }

  String _getStatusText() {
    final now = DateTime.now();
    final daysUntilDue = assignment.dueDate.difference(now).inDays;
    
    if (assignment.dueDate.isBefore(now)) {
      return 'OVERDUE';
    } else if (daysUntilDue == 0) {
      return 'DUE TODAY';
    } else if (daysUntilDue <= 3) {
      return 'DUE SOON';
    } else {
      return 'ACTIVE';
    }
  }
}
