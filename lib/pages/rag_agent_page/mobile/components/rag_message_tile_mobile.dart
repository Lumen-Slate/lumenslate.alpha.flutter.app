import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lumen_slate/pages/rag_agent_page/desktop/components/rag_generated_questions_tile.dart';
import '../../../../serializers/rag_agent_serializers/rag_generated_questions_serializer.dart';
import '../../../../serializers/rag_agent_serializers/reg_agent_response.dart';

class RagMessageTileMobile extends StatelessWidget {
  final RagAgentResponse message;

  const RagMessageTileMobile({super.key, required this.message});

  String _formatTime(DateTime? utcTime) {
    if (utcTime == null) return '';
    final localTime = utcTime.toLocal();
    return DateFormat('hh:mm a').format(localTime);
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.agentName == 'user';
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            // RAG Agent Avatar
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.green[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy,
                size: 20,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Message Bubble
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser 
                        ? Colors.blue[100] 
                        : Colors.green[50],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isUser 
                          ? const Radius.circular(16) 
                          : const Radius.circular(4),
                      bottomRight: isUser 
                          ? const Radius.circular(4) 
                          : const Radius.circular(16),
                    ),
                    border: Border.all(
                      color: isUser 
                          ? Colors.blue.withValues(alpha: 0.2)
                          : Colors.green.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Agent Name
                      Text(
                        isUser ? 'You' : 'RAG Agent',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: isUser 
                              ? Colors.blue[700]
                              : Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Message Content
                      Text(
                        message.message,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      
                      // Generated Questions Component (if present)
                      if (message.data != null) ...[
                        const SizedBox(height: 8),
                        RagGeneratedQuestionsTile(
                          serializer: message.data as RagGeneratedQuestionsSerializer,
                          bankId: 'd624d970-2bbf-41cc-9ddc-f95358f74cbf',
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Timestamp
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
                  child: Text(
                    _formatTime(message.createdAt),
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            // User Avatar
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 20,
                color: Colors.blue[700],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
