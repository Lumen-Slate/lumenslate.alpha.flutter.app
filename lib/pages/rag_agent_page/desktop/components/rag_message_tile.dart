import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lumen_slate/pages/rag_agent_page/desktop/components/rag_generated_questions_tile.dart';

import '../../../../serializers/rag_agent_serializers/rag_generated_questions_serializer.dart';
import '../../../../serializers/rag_agent_serializers/reg_agent_response.dart';
import 'package:flutter/material.dart';

class RagMessageTile extends StatelessWidget {
  final RagAgentResponse message;

  const RagMessageTile({super.key, required this.message});

  String _formatTime(DateTime? utcTime) {
    if (utcTime == null) return '';
    final localTime = utcTime.toLocal();
    return DateFormat('hh:mm a').format(localTime);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.agentName == 'user' ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.agentName == 'user' ? Colors.blue[100] : Colors.green[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Agent',
              style: GoogleFonts.jost(fontWeight: FontWeight.w700, color: Colors.grey[700]),
            ),
            Text(message.message, style: GoogleFonts.jost(fontSize: 14, color: Colors.black87)),

            if (message.data != null)
              RagGeneratedQuestionsTile(
                serializer: message.data as RagGeneratedQuestionsSerializer,
                bankId: 'd624d970-2bbf-41cc-9ddc-f95358f74cbf',
              ),

            Text(_formatTime(message.createdAt), style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
