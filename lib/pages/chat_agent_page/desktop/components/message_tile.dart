import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lumen_slate/serializers/agent_serializers/agent_response.dart';
import '../../../../serializers/agent_serializers/assignment_generator_general_serializer.dart';
import 'assignment_generator_general_tile.dart';
import 'assessor_agent_tile.dart';
import '../../../../serializers/agent_serializers/assessor_agent_serializer.dart';

class MessageTile extends StatelessWidget {
  final AgentResponse message;

  const MessageTile({super.key, required this.message});

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
              message.agentName == 'user' ? 'User' : 'Agent',
              style: GoogleFonts.jost(fontWeight: FontWeight.w700, color: Colors.grey[700]),
            ),
            Text(message.message, style: GoogleFonts.jost(fontSize: 14, color: Colors.black87)),

            if (message.agentName == 'assignment_generator_general' ||
                message.agentName == 'assignment_generator_tailored')
              AssignmentGeneratorTile(
                serializer: AssignmentGeneratorSerializer(
                  assignmentId: message.data.assignmentId,
                  title: message.data.title,
                  body: message.data.body,
                  mcqCount: message.data.mcqCount,
                  natCount: message.data.natCount,
                  msqCount: message.data.msqCount,
                  subjectiveCount: message.data.subjectiveCount,
                ),
              ),

            if (message.agentName == 'assessor_agent')
              AssessorAgentTile(
                serializer: AssessorAgentSerializer.fromJson(message.data.toJson()),
              ),

            Text(_formatTime(message.createdAt), style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
