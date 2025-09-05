import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../serializers/agent_serializers/agent_response.dart';
import '../../../../widgets/context_menu_item.dart';
import '../response_message.dart';

final class TextResponseMessage extends StatelessWidget implements ResponseMessage {
  final AIRawResponse response;

  const TextResponseMessage({super.key, required this.response});

  String _formatTime(DateTime? utcTime) {
    if (utcTime == null) return '';
    final localTime = utcTime.toLocal();
    return DateFormat('hh:mm a').format(localTime);
  }

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      contextMenu: ContextMenu(
        entries: [
          CustomContextMenuItem(
            label: 'Copy',
            icon: Icons.copy,
            onSelected: () {
              Clipboard.setData(ClipboardData(text: response.message));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message copied to clipboard')));
            },
          ),
          CustomContextMenuItem(
            label: 'Response Info',
            icon: Icons.info,
            onSelected: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Response Info'),
                  content: Text(
                    'Agent: ${response.agentName}\nResponse Time: ${response.responseTime.toStringAsFixed(2)} seconds',
                  ),
                  actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
                ),
              );
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
        decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(12)),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lumen Agent",
              style: GoogleFonts.jost(fontWeight: FontWeight.w700, color: Colors.grey[700]),
            ),
            Text(response.message, style: GoogleFonts.jost(fontSize: 14, color: Colors.black87)),

            Text(_formatTime(response.createdAt), style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
