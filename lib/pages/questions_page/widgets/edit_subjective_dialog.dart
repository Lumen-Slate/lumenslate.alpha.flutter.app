import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/questions/subjective.dart';

class EditSubjectiveDialog extends StatefulWidget {
  final Subjective subjective;

  const EditSubjectiveDialog({super.key, required this.subjective});

  @override
  State<EditSubjectiveDialog> createState() => _EditSubjectiveDialogState();
}

class _EditSubjectiveDialogState extends State<EditSubjectiveDialog> {
  late TextEditingController questionController;
  late TextEditingController pointsController;
  late TextEditingController idealAnswerController;
  late List<TextEditingController> criteriaControllers;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.subjective.question);
    pointsController = TextEditingController(text: widget.subjective.points.toString());
    idealAnswerController = TextEditingController(text: widget.subjective.idealAnswer ?? '');
    
    // Initialize criteria controllers
    criteriaControllers = (widget.subjective.gradingCriteria ?? [])
        .map((criteria) => TextEditingController(text: criteria))
        .toList();
    
    // Ensure we have at least one criteria field
    if (criteriaControllers.isEmpty) {
      criteriaControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    pointsController.dispose();
    idealAnswerController.dispose();
    for (var controller in criteriaControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addCriteria() {
    setState(() {
      criteriaControllers.add(TextEditingController());
    });
  }

  void _removeCriteria(int index) {
    if (criteriaControllers.length > 1) {
      setState(() {
        criteriaControllers[index].dispose();
        criteriaControllers.removeAt(index);
      });
    }
  }

  Subjective _buildUpdatedSubjective() {
    return widget.subjective.copyWith(
      question: questionController.text.trim(),
      points: int.tryParse(pointsController.text) ?? widget.subjective.points,
      idealAnswer: idealAnswerController.text.trim().isEmpty 
          ? null 
          : idealAnswerController.text.trim(),
      gradingCriteria: criteriaControllers
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty)
          .toList(),
    );
  }

  bool _isValid() {
    final question = questionController.text.trim();
    final points = int.tryParse(pointsController.text);

    return question.isNotEmpty && points != null && points > 0;
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
                Icon(Icons.assignment, color: Colors.purple[600]),
                const SizedBox(width: 12),
                Text(
                  'Edit Subjective Question',
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
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Enter your subjective question here...',
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
                          onPressed: _addCriteria,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Criteria'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Ideal Answer field
                    Text(
                      'Ideal Answer (Optional)',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: idealAnswerController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Enter the ideal answer or key points...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Grading Criteria
                    Text(
                      'Grading Criteria',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.purple.shade200),
                      ),
                      child: Text(
                        'Define the key points or criteria used for evaluating student answers.',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...criteriaControllers.asMap().entries.map((entry) {
                      int index = entry.key;
                      TextEditingController controller = entry.value;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            // Criteria number
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.purple[100],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple[800],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Criteria text field
                            Expanded(
                              child: TextField(
                                controller: controller,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  hintText: 'Grading criteria ${index + 1}',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            // Remove button
                            if (criteriaControllers.length > 1)
                              IconButton(
                                onPressed: () => _removeCriteria(index),
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
                      ? () => Navigator.of(context).pop(_buildUpdatedSubjective())
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