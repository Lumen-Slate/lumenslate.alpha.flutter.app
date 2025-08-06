import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../serializers/agent_serializers/report_card_agent.dart';

class ReportCardAgentTile extends StatelessWidget {
  final ReportCardAgentSerializer serializer;

  const ReportCardAgentTile({super.key, required this.serializer});

  @override
  Widget build(BuildContext context) {
    final reportCard = serializer.reportCard;
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Report Card', style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 8),
            Text('Student: ${reportCard.studentName}', style: GoogleFonts.jost(fontSize: 16)),
            Text('Period: ${reportCard.reportPeriod}', style: GoogleFonts.jost(fontSize: 14)),
            Text('Generated: ${reportCard.generationDate}', style: GoogleFonts.jost(fontSize: 12, color: Colors.grey)),
            const Divider(height: 24),
            Text('Overall Performance', style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 16)),
            Text('Assignments Completed: ${reportCard.overallPerformance.totalAssignmentsCompleted}', style: GoogleFonts.jost(fontSize: 14)),
            Text('Overall %: ${reportCard.overallPerformance.overallPercentage.toStringAsFixed(2)}', style: GoogleFonts.jost(fontSize: 14)),
            Text('Trend: ${reportCard.overallPerformance.improvementTrend}', style: GoogleFonts.jost(fontSize: 14)),
            Text('Strongest Q Type: ${reportCard.overallPerformance.strongestQuestionType}', style: GoogleFonts.jost(fontSize: 14)),
            Text('Weakest Q Type: ${reportCard.overallPerformance.weakestQuestionType}', style: GoogleFonts.jost(fontSize: 14)),
            const Divider(height: 24),
            Text('Subjects', style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 16)),
            ...reportCard.subjectPerformance.map((subject) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject.subjectName, style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text('Score: ${subject.percentageScore.toStringAsFixed(2)}%', style: GoogleFonts.jost(fontSize: 13)),
                  Text('Assignments: ${subject.assignmentCount}', style: GoogleFonts.jost(fontSize: 13)),
                  Text('MCQ Accuracy: ${subject.mcqAccuracy.toStringAsFixed(2)}%', style: GoogleFonts.jost(fontSize: 13)),
                  Text('MSQ Accuracy: ${subject.msqAccuracy.toStringAsFixed(2)}%', style: GoogleFonts.jost(fontSize: 13)),
                  Text('NAT Accuracy: ${subject.natAccuracy.toStringAsFixed(2)}%', style: GoogleFonts.jost(fontSize: 13)),
                  Text('Subjective Avg: ${subject.subjectiveAvgScore.toStringAsFixed(2)}', style: GoogleFonts.jost(fontSize: 13)),
                  Text('Strengths: ${subject.strengths.join(', ')}', style: GoogleFonts.jost(fontSize: 13, color: Colors.green[700])),
                  Text('Weaknesses: ${subject.weaknesses.join(', ')}', style: GoogleFonts.jost(fontSize: 13, color: Colors.red[700])),
                  Text('Trend: ${subject.improvementTrend}', style: GoogleFonts.jost(fontSize: 13)),
                ],
              ),
            )),
            const Divider(height: 24),
            Text('Assignments', style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 16)),
            ...reportCard.assignmentSummaries.map((a) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text('${a.assignmentTitle} (${a.subject}): ${a.percentageScore.toStringAsFixed(2)}%', style: GoogleFonts.jost(fontSize: 13)),
            )),
            const Divider(height: 24),
            Text('AI Remarks', style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 15)),
            Text(reportCard.aiRemarks, style: GoogleFonts.jost(fontSize: 13)),
            const SizedBox(height: 8),
            Text('Teacher Remarks', style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 15)),
            Text(reportCard.teacherRemarks, style: GoogleFonts.jost(fontSize: 13)),
            const Divider(height: 24),
            Text('Student Insights', style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 15)),
            Text('Strengths: ${reportCard.studentInsights.keyStrengths.join(', ')}', style: GoogleFonts.jost(fontSize: 13, color: Colors.green[700])),
            Text('Areas for Improvement: ${reportCard.studentInsights.areasForImprovement.join(', ')}', style: GoogleFonts.jost(fontSize: 13, color: Colors.red[700])),
            Text('Recommended Actions: ${reportCard.studentInsights.recommendedActions.join(', ')}', style: GoogleFonts.jost(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

