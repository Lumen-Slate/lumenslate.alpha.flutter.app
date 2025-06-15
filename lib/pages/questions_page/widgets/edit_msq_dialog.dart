import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/questions/msq.dart';

class EditMSQDialog extends StatefulWidget {
  final MSQ msq;

  const EditMSQDialog({super.key, required this.msq});

  @override
  State<EditMSQDialog> createState() => _EditMSQDialogState();
}

class _EditMSQDialogState extends State<EditMSQDialog> {
  late TextEditingController questionController;
  late TextEditingController pointsController;
  late List<TextEditingController> optionControllers;
  late Set<int> selectedAnswerIndices;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.msq.question);
    pointsController = TextEditingController(text: widget.msq.points.toString());
    selectedAnswerIndices = Set<int>.from(widget.msq.answerIndices);
    
    // Initialize option controllers
    optionControllers = widget.msq.options
        .map((option) => TextEditingController(text: option))
        .toList();
    
    // Ensure we have at least 2 options
    while (optionControllers.length < 2) {
      optionControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    pointsController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() {
      optionControllers.add(TextEditingController());
    });
  }

  void _removeOption(int index) {
    if (optionControllers.length > 2) {
      setState(() {
        optionControllers[index].dispose();
        optionControllers.removeAt(index);
        
        // Adjust answer indices
        selectedAnswerIndices.remove(index);
        Set<int> adjustedIndices = {};
        for (int selectedIndex in selectedAnswerIndices) {
          if (selectedIndex > index) {
            adjustedIndices.add(selectedIndex - 1);
          } else {
            adjustedIndices.add(selectedIndex);
          }
        }
        selectedAnswerIndices = adjustedIndices;
      });
    }
  }

  MSQ _buildUpdatedMSQ() {
    return widget.msq.copyWith(
      question: questionController.text.trim(),
      points: int.tryParse(pointsController.text) ?? widget.msq.points,
      options: optionControllers
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty)
          .toList(),
      answerIndices: selectedAnswerIndices.toList()..sort(),
    );
  }

  bool _isValid() {
    final question = questionController.text.trim();
    final points = int.tryParse(pointsController.text);
    final options = optionControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    return question.isNotEmpty &&
        points != null &&
        points > 0 &&
        options.length >= 2 &&
        selectedAnswerIndices.isNotEmpty &&
        selectedAnswerIndices.every((index) => index < options.length);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.checklist, color: Colors.green[600]),
                const SizedBox(width: 12),
                Text(
                  'Edit MSQ Question',
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
            
            // Form content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        hintText: 'Enter your question here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Points field
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
                        const SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: _addOption,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Option'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Options
                    Text(
                      'Options (Select all correct answers)',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Text(
                        'Note: This is a Multiple Select Question - multiple options can be correct.',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...optionControllers.asMap().entries.map((entry) {
                      int index = entry.key;
                      TextEditingController controller = entry.value;
                      bool isSelected = selectedAnswerIndices.contains(index);
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            // Checkbox for multiple correct answers
                            Checkbox(
                              value: isSelected,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedAnswerIndices.add(index);
                                  } else {
                                    selectedAnswerIndices.remove(index);
                                  }
                                });
                              },
                            ),
                            // Option letter
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? Colors.green[100] 
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index), // A, B, C, D...
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected 
                                        ? Colors.green[800] 
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Option text field
                            Expanded(
                              child: TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                  hintText: 'Option ${String.fromCharCode(65 + index)}',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            // Remove button
                            if (optionControllers.length > 2)
                              IconButton(
                                onPressed: () => _removeOption(index),
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                    
                    // Selected answers summary
                    if (selectedAnswerIndices.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Correct Answers:',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue.shade800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 8,
                              children: selectedAnswerIndices.map((index) {
                                return Chip(
                                  label: Text(
                                    String.fromCharCode(65 + index),
                                    style: GoogleFonts.poppins(fontSize: 12),
                                  ),
                                  backgroundColor: Colors.green.shade100,
                                  side: BorderSide(color: Colors.green.shade300),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Action buttons
            const SizedBox(height: 20),
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
                      ? () => Navigator.of(context).pop(_buildUpdatedMSQ())
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