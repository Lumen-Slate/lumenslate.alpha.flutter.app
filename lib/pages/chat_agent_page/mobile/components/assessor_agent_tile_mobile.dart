import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../serializers/agent_serializers/assessor_agent_serializer.dart';

class AssessorAgentTileMobile extends StatelessWidget {
  final AssessorAgentSerializer serializer;

  const AssessorAgentTileMobile({super.key, required this.serializer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assessment Summary',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          
          // Score overview
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Points:',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    Text(
                      '${serializer.totalPointsAwarded} / ${serializer.totalMaxPoints}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Percentage:',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    Text(
                      '${serializer.percentageScore.toStringAsFixed(1)}%',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _getScoreColor(serializer.percentageScore),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Results sections
          if (serializer.mcqResults != null && serializer.mcqResults!.isNotEmpty)
            _buildResultSection(
              'MCQ Results',
              serializer.mcqResults!.length,
              Colors.blue,
            ),
            
          if (serializer.msqResults != null && serializer.msqResults!.isNotEmpty)
            _buildResultSection(
              'MSQ Results',
              serializer.msqResults!.length,
              Colors.green,
            ),
            
          if (serializer.natResults != null && serializer.natResults!.isNotEmpty)
            _buildResultSection(
              'NAT Results',
              serializer.natResults!.length,
              Colors.orange,
            ),
            
          if (serializer.subjectiveResults != null && serializer.subjectiveResults!.isNotEmpty)
            _buildResultSection(
              'Subjective Results',
              serializer.subjectiveResults!.length,
              Colors.purple,
            ),
        ],
      ),
    );
  }

  Widget _buildResultSection(String title, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '$count questions',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }
}
