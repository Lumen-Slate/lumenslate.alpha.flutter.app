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
    pointsController = TextEditingController(
      text: widget.mcq.points.toString(),
    );
    selectedAnswerIndex = widget.mcq.answerIndex;

    optionControllers = widget.mcq.options
        .map((option) => TextEditingController(text: option))
        .toList();

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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 1300,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 55),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Edit MCQ Question',
                    style: GoogleFonts.jost(
                      fontSize: 56,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Update the question and its options below.',
                style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 24),

              // Question field
              Text(
                'Question',
                style: GoogleFonts.poppins(
                  fontSize: 18,
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
              ),
              const SizedBox(height: 20),

              // Points and Add Option
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Points',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade300,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Options
              Text(
                'Options (Select the correct answer)',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              ...optionControllers.asMap().entries.map((entry) {
                int index = entry.key;
                TextEditingController controller = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedAnswerIndex == index ? Colors.teal : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: selectedAnswerIndex == index ? Colors.teal.withValues(alpha: 0.08) : Colors.white,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setState(() {
                        selectedAnswerIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      child: Row(
                        children: [
                          Radio<int>(
                            value: index,
                            groupValue: selectedAnswerIndex,
                            onChanged: (value) {
                              setState(() {
                                selectedAnswerIndex = value!;
                              });
                            },
                            activeColor: Colors.teal,
                          ),
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
                                String.fromCharCode(65 + index),
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
                          Expanded(
                            child: TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                hintText: 'Option ${String.fromCharCode(65 + index)}',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                              ),
                            ),
                          ),
                          if (optionControllers.length > 2)
                            IconButton(
                              onPressed: () => _removeOption(index),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              // Action buttons
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.shade200,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _isValid()
                        ? () => Navigator.of(context).pop(_buildUpdatedMCQ())
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade300,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    ),
                    icon: const Icon(Icons.save),
                    label: Text(
                      'Save Changes',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
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
