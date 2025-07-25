import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/students.dart';
import '../../../../models/assignments.dart';
import 'student_selection_dialog_mobile.dart';
import 'assignment_selection_dialog_mobile.dart';

class AttachmentBottomSheet extends StatelessWidget {
  final Function(PlatformFile) onFileSelected;
  final Function(Student) onStudentSelected;
  final Function(Assignment) onAssignmentSelected;

  const AttachmentBottomSheet({
    super.key,
    required this.onFileSelected,
    required this.onStudentSelected,
    required this.onAssignmentSelected,
  });

  Future<PlatformFile?> _pickSupportedFile(BuildContext context) async {
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
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unsupported file type selected.')),
          );
        }
        return null;
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: ${file.name}')),
        );
      }
      return file;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Attachment',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // File attachment
                  _buildAttachmentOption(
                    icon: Icons.file_copy,
                    title: 'File',
                    subtitle: 'Attach a document, image, or audio file',
                    color: Colors.blue,
                    onTap: () async {
                      context.pop();
                      final file = await _pickSupportedFile(context);
                      if (file != null) {
                        onFileSelected(file);
                      }
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Student attachment
                  _buildAttachmentOption(
                    icon: Icons.school_outlined,
                    title: 'Student',
                    subtitle: 'Select a student for context',
                    color: Colors.green,
                    onTap: () async {
                      context.pop();
                      final student = await showDialog<Student?>(
                        context: context,
                        builder: (context) => const StudentSelectionDialogMobile(),
                      );
                      if (student != null) {
                        onStudentSelected(student);
                      }
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Assignment attachment
                  _buildAttachmentOption(
                    icon: Icons.assignment,
                    title: 'Assignment',
                    subtitle: 'Select an assignment for context',
                    color: Colors.orange,
                    onTap: () async {
                      context.pop();
                      final assignment = await showDialog<Assignment?>(
                        context: context,
                        builder: (context) => const AssignmentSelectionDialogMobile(),
                      );
                      if (assignment != null) {
                        onAssignmentSelected(assignment);
                      }
                    },
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
