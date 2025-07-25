import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../serializers/agent_serializers/agent_response.dart';
import '../../../../serializers/agent_serializers/assignment_generator_general_serializer.dart';
import '../../../../serializers/agent_serializers/assessor_agent_serializer.dart';
import 'assignment_generator_tile_mobile.dart';
import 'assessor_agent_tile_mobile.dart';

class MessageTileMobile extends StatelessWidget {
  final AgentResponse message;

  const MessageTileMobile({super.key, required this.message});

  String _formatTime(DateTime? utcTime) {
    if (utcTime == null) return '';
    final localTime = utcTime.toLocal();
    return DateFormat('hh:mm a').format(localTime);
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.agentName == 'user';
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green[100],
              child: Icon(
                Icons.smart_toy,
                size: 16,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue[100] : Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser)
                    Text(
                      'Lumen Agent',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    message.message,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),

                  // Special content for different agent types
                  if (message.agentName == 'assignment_generator_general' ||
                      message.agentName == 'assignment_generator_tailored')
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: AssignmentGeneratorTileMobile(
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
                    ),

                  if (message.agentName == 'assessor_agent')
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: AssessorAgentTileMobile(
                        serializer: AssessorAgentSerializer.fromJson(message.data.toJson()),
                      ),
                    ),

                  const SizedBox(height: 4),
                  
                  Text(
                    _formatTime(message.createdAt),
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[100],
              child: Icon(
                Icons.person,
                size: 16,
                color: Colors.blue[800],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
