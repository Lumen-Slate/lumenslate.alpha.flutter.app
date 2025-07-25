import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumen_slate/lib.dart';
import 'package:lumen_slate/pages/chat_agent_page/desktop/components/student_selection_dialog.dart';
import 'package:lumen_slate/pages/chat_agent_page/desktop/components/assignment_selection_dialog.dart';

import '../../../../models/students.dart';
import '../../../../models/assignments.dart';

class AttachmentPopUp extends StatefulWidget {
  final GlobalKey<CustomPopupState> popupKey;
  final Function(PlatformFile) onFileSelected;
  final Function(Student) onStudentSelected;
  final Function(Assignment) onAssignmentSelected;

  const AttachmentPopUp({
    super.key,
    required this.popupKey,
    required this.onFileSelected,
    required this.onStudentSelected,
    required this.onAssignmentSelected,
  });

  @override
  State<AttachmentPopUp> createState() => _AttachmentPopUpState();
}

class _AttachmentPopUpState extends State<AttachmentPopUp> {
  /// TODO - Replace with actual teacher ID
  final String teacherId = '0692d515-1621-44ea-85e7-a41335858ee2';
  Future<PlatformFile?> _pickSupportedFile() async {
    final allowedExtensions = [
      // Images
      'jpg', 'jpeg', 'png', 'webp',
      // Audio
      'wav', 'mp3', 'aiff', 'aac', 'ogg', 'flac',
      // Text
      'pdf',
    ];
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final ext = file.extension?.toLowerCase();
      if (!allowedExtensions.contains(ext)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unsupported file type selected.')));
        return null;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected: ${file.name}')));
      return file;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopup(
      position: PopupPosition.top,
      key: widget.popupKey,
      contentRadius: 30,
      contentPadding: const EdgeInsets.all(40),
      content: Container(
        constraints: BoxConstraints(maxHeight: 900, maxWidth: 900),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 270,
              height: 270,
              child: FilledButton(
                onPressed: () async {
                  final PlatformFile? result = await _pickSupportedFile();
                  if (result == null) return;
                  widget.onFileSelected(result);
                  context.pop();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blue[100],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.file_copy, size: 50, color: Colors.blue[800]),
                    Text('File', style: GoogleFonts.poppins(fontSize: 36, color: Colors.blue[800])),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 270,
              height: 270,
              child: FilledButton(
                onPressed: () async {
                  context.pop();
                  final Student? result = await showDialog<Student?>(context: context, builder: (context) => const StudentSelectionDialog());
                  if (result == null) return;
                  widget.onStudentSelected(result);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green[100],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  minimumSize: const Size(270, 270),
                ),
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.school_outlined, size: 50, color: Colors.green[800]),
                    Text('Student', style: GoogleFonts.poppins(fontSize: 36, color: Colors.green[800])),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 270,
              height: 270,
              child: FilledButton(
                onPressed: () async {
                  context.pop();
                  final Assignment? result = await showDialog<Assignment?>(
                    context: context,
                    builder: (context) => AssignmentSelectionDialog(
                      teacherId: teacherId,
                    ),
                  );
                  if (result == null) return;
                  widget.onAssignmentSelected(result);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.orange[100],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  minimumSize: const Size(270, 270),
                ),
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment_add, size: 50, color: Colors.orange[800]),
                    Text('Assignment', style: GoogleFonts.poppins(fontSize: 36, color: Colors.orange[800])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      child: IconButton(
        padding: const EdgeInsets.all(20.0),
        style: IconButton.styleFrom(backgroundColor: Colors.blue[100], shape: CircleBorder()),
        icon: const Icon(Icons.attach_file, color: Colors.blue),
        tooltip: 'Attach file',
        onPressed: () {
          widget.popupKey.currentState?.show();
        },
      ),
    );
  }
}
