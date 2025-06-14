import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/questions/nat.dart';

class EditNATDialog extends StatefulWidget {
  final NAT nat;

  const EditNATDialog({super.key, required this.nat});

  @override
  State<EditNATDialog> createState() => _EditNATDialogState();
}

class _EditNATDialogState extends State<EditNATDialog> {
  late TextEditingController questionController;
  late TextEditingController pointsController;
  late TextEditingController answerController;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.nat.question);
    pointsController = TextEditingController(text: widget.nat.points.toString());
    answerController = TextEditingController(text: widget.nat.answer.toString());
  }

  @override
  void dispose() {
    questionController.dispose();
    pointsController.dispose();
    answerController.dispose();
    super.dispose();
  }

  NAT _buildUpdatedNAT() {
    return widget.nat.copyWith(
      question: questionController.text.trim(),
      points: int.tryParse(pointsController.text) ?? widget.nat.points,
      answer: double.tryParse(answerController.text) ?? widget.nat.answer,
    );
  }

  bool _isValid() {
    final question = questionController.text.trim();
    final points = int.tryParse(pointsController.text);
    final answer = double.tryParse(answerController.text);

    return question.isNotEmpty &&
        points != null &&
        points > 0 &&
        answer != null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.numbers, color: Colors.orange[600]),
                const SizedBox(width: 12),
                Text(
                  'Edit NAT Question',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Question field
            Text(
              'Question',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: questionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter your numerical question here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Points and Answer fields
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Points',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: pointsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Points',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Correct Answer',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: answerController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: 'Numerical answer',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel', style: GoogleFonts.poppins()),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isValid()
                      ? () => Navigator.of(context).pop(_buildUpdatedNAT())
                      : null,
                  child: Text('Save Changes', style: GoogleFonts.poppins()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 