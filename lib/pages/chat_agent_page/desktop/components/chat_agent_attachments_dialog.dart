import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumen_slate/lib.dart';


class ChatAgentAttachmentsDialog extends StatelessWidget {
  final VoidCallback onClose;

  const ChatAgentAttachmentsDialog({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: AppConstants.desktopScaleWidth,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              // file tile
              Container(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(Icons.attach_file, color: Colors.blue),
                  title: Text('File Attachment'),
                  subtitle: Text('Click to attach a file'),
                  onTap: () {
                    // Handle file attachment logic here
                    context.pop();
                    onClose();
                  },
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}