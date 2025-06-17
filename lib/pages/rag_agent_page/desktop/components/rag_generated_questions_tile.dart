import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../serializers/rag_agent_serializers/rag_generated_questions_serializer.dart';
import 'generated_questions_choice_dialog.dart';

class RagGeneratedQuestionsTile extends StatelessWidget {
  final RagGeneratedQuestionsSerializer serializer;
  final String bankId;

  const RagGeneratedQuestionsTile({
    super.key,
    required this.serializer,
    required this.bankId,
  });

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
            Text('Corpus Used: ${serializer.corpusUsed}', style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text('Total Questions Generated: ${serializer.totalQuestionsGenerated}', style: GoogleFonts.jost(fontSize: 14)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildCount('MCQ', serializer.mcqs.length),
                _buildCount('MSQ', serializer.msqs.length),
                _buildCount('NAT', serializer.nats.length),
                _buildCount('Subjective', serializer.subjectives.length),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.blue[100],
              ),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (ctx) => GeneratedQuestionsChoiceDialog(
                    serializer: serializer,
                    bankId: bankId,
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Select & Save Questions', style: GoogleFonts.jost(fontSize: 14)),
                  const SizedBox(width: 8),
                  Icon(Icons.save, size: 16, color: Colors.blue[800]),
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
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(count.toString(), style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

