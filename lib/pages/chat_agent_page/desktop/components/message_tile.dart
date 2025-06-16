import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/chat_message.dart';

class MessageTile extends StatelessWidget {
  final ChatMessage message;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.agentName,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            Text(message.message),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.createdAt),
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}