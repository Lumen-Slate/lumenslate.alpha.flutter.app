import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/context_menu_item.dart';
import '../request_message.dart';

final class TextRequestMessage extends StatelessWidget implements RequestMessage {
  final String content;
  final String senderName;
  final String teacherId;
  final String sessionId;
  final DateTime createdAt;
  final DateTime updatedAt;

  String _formatTime(DateTime? utcTime) {
    if (utcTime == null) return '';
    final localTime = utcTime.toLocal();
    return DateFormat('hh:mm a').format(localTime);
  }

  const TextRequestMessage({
    super.key,
    required this.content,
    required this.teacherId,
    required this.sessionId,
    required this.createdAt,
    required this.updatedAt,
    required this.senderName,
  });

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      contextMenu: ContextMenu(
        entries: [
          CustomContextMenuItem(
            label: 'Copy',
            icon: Icons.copy,
            onSelected: () {
              Clipboard.setData(ClipboardData(text: content));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message copied to clipboard')));
            },
          ),
        ],
        padding: const EdgeInsets.symmetric(vertical: 8),
        boxDecoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(12)),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              senderName,
              style: GoogleFonts.jost(fontWeight: FontWeight.w700, color: Colors.grey[700]),
            ),
            Text(content, style: GoogleFonts.jost(fontSize: 14, color: Colors.black87)),

            Text(_formatTime(createdAt), style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
