import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../serializers/agent_serializers/assessor_agent_serializer.dart';

class AssessorAgentTile extends StatelessWidget {
  final AssessorAgentSerializer serializer;

  const AssessorAgentTile({super.key, required this.serializer});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assessment Summary', style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              'Total Points: ${serializer.totalPointsAwarded} / ${serializer.totalMaxPoints}',
              style: GoogleFonts.jost(fontSize: 14),
            ),
            Text(
              'Percentage Score: ${serializer.percentageScore.toStringAsFixed(2)}%',
              style: GoogleFonts.jost(fontSize: 14),
            ),
            const SizedBox(height: 12),
            if (serializer.mcqResults != null && serializer.mcqResults!.isNotEmpty)
              _buildSection(
                'MCQ Results',
                serializer.mcqResults!.asMap().entries.map((entry) {
                  final i = entry.key;
                  final e = entry.value;
                  return 'Q: ${i + 1} | Your Ans: ${e.studentAnswer} | Correct: ${e.correctAnswer} | Points: ${e.pointsAwarded}/${e.maxPoints} | ${e.isCorrect ? "Correct" : "Wrong"}';
                }).toList(),
              ),
            if (serializer.msqResults != null && serializer.msqResults!.isNotEmpty)
              _buildSection(
                'MSQ Results',
                serializer.msqResults!.asMap().entries.map((entry) {
                  final i = entry.key;
                  final e = entry.value;
                  return 'Q: ${i + 1} | Your Ans: ${e.studentAnswers.join(",")} | Correct: ${e.correctAnswers.join(",")} | Points: ${e.pointsAwarded}/${e.maxPoints} | ${e.isCorrect ? "Correct" : "Wrong"}';
                }).toList(),
              ),
            if (serializer.natResults != null && serializer.natResults!.isNotEmpty)
              _buildSection(
                'NAT Results',
                serializer.natResults!.asMap().entries.map((entry) {
                  final i = entry.key;
                  final e = entry.value;
                  return 'Q: ${i + 1} | Your Ans: ${e.studentAnswer} | Correct: ${e.correctAnswer} | Points: ${e.pointsAwarded}/${e.maxPoints} | ${e.isCorrect ? "Correct" : "Wrong"}';
                }).toList(),
              ),
            if (serializer.subjectiveResults != null && serializer.subjectiveResults!.isNotEmpty)
              _buildSection(
                'Subjective Results',
                serializer.subjectiveResults!.asMap().entries.map((entry) {
                  final i = entry.key;
                  final e = entry.value;
                  return 'Q: ${i + 1} | Points: ${e.pointsAwarded}/${e.maxPoints}\nFeedback: ${e.assessmentFeedback}';
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 4),
          ...items.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(e, style: GoogleFonts.jost(fontSize: 13)),
          )),
        ],
      ),
    );
  }
}
