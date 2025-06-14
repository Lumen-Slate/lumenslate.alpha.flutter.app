import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/questions/mcq.dart';

class EditMCQDialog extends StatefulWidget {
  final MCQ mcq;

  const EditMCQDialog({super.key, required this.mcq});

  @override
  State<EditMCQDialog> createState() => _EditMCQDialogState();
}

class _EditMCQDialogState extends State<EditMCQDialog> {
  late TextEditingController questionController;
  late TextEditingController pointsController;
  late List<TextEditingController> optionControllers;
  late int selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.mcq.question);
    pointsController = TextEditingController(text: widget.mcq.points.toString());
    selectedAnswerIndex = widget.mcq.answerIndex;
    
    // Initialize option controllers
    optionControllers = widget.mcq.options
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
        
        // Adjust answer index if necessary
        if (selectedAnswerIndex == index) {
          selectedAnswerIndex = 0;
        } else if (selectedAnswerIndex > index) {
          selectedAnswerIndex--;
        }
      });
    }
  }

  MCQ _buildUpdatedMCQ() {
    return widget.mcq.copyWith(
      question: questionController.text.trim(),
      points: int.tryParse(pointsController.text) ?? widget.mcq.points,
      options: optionControllers
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty)
          .toList(),
      answerIndex: selectedAnswerIndex,
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
        selectedAnswerIndex < options.length;
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
                Icon(Icons.quiz, color: Colors.blue[600]),
                const SizedBox(width: 12),
                Text(
                  'Edit MCQ Question',
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
                      'Options (Select the correct answer)',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...optionControllers.asMap().entries.map((entry) {
                      int index = entry.key;
                      TextEditingController controller = entry.value;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            // Radio button for correct answer
                            Radio<int>(
                              value: index,
                              groupValue: selectedAnswerIndex,
                              onChanged: (value) {
                                setState(() {
                                  selectedAnswerIndex = value!;
                                });
                              },
                            ),
                            // Option letter
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: selectedAnswerIndex == index 
                                    ? Colors.green[100] 
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index), // A, B, C, D...
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: selectedAnswerIndex == index 
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
                      ? () => Navigator.of(context).pop(_buildUpdatedMCQ())
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