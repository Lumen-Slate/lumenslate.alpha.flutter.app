import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateBankDialog extends StatefulWidget {
  final Future<bool> Function(String name, String topic, List<String> tags) onCreate;

  const CreateBankDialog({super.key, required this.onCreate});

  @override
  State<CreateBankDialog> createState() => _CreateBankDialogState();
}

class _CreateBankDialogState extends State<CreateBankDialog> {
  final nameController = TextEditingController();
  final topicController = TextEditingController();
  final tagsController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    nameController.dispose();
    topicController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Question Bank', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 18),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: topicController,
                decoration: InputDecoration(
                  labelText: 'Topic',
                  labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: tagsController,
                decoration: InputDecoration(
                  labelText: 'Tags (comma separated)',
                  labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(errorMessage!, style: GoogleFonts.poppins(color: Colors.red, fontSize: 14)),
              ],
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                    child: Text('Cancel', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            final name = nameController.text.trim();
                            final topic = topicController.text.trim();
                            final tags = tagsController.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
                            if (name.isEmpty || topic.isEmpty || tags.isEmpty) {
                              setState(() => errorMessage = 'All fields are required.');
                              return;
                            }
                            setState(() => isLoading = true);
                            final success = await widget.onCreate(name, topic, tags);
                            setState(() => isLoading = false);
                            if (success) {
                              Navigator.of(context).pop();
                            } else {
                              setState(() => errorMessage = 'Failed to create. Please try again.');
                            }
                          },
                    child: isLoading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text('Create', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

