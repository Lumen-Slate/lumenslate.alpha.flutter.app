import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../blocs/context_generation/context_generation_bloc.dart';
import '../../../../blocs/questions/questions_bloc.dart';

class ContextGenerationDialog extends StatefulWidget {
  final String question;
  final String id;
  final String type;

  const ContextGenerationDialog({
    super.key,
    required this.question,
    required this.id,
    required this.type,
  });

  @override
  ContextGenerationDialogState createState() => ContextGenerationDialogState();
}

class ContextGenerationDialogState extends State<ContextGenerationDialog> {
  final TextEditingController _keywordController = TextEditingController();
  final List<String> _keywords = [];
  String _generatedContext = '';
  final TextEditingController _contextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _addKeyword(String keyword) {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _keywords.add(keyword);
        _keywordController.clear();
      });
    }
  }

  void _removeKeyword(String keyword) {
    setState(() {
      _keywords.remove(keyword);
    });
  }

  void _generateContext() {
    context.read<ContextGeneratorBloc>().add(GenerateContext(widget.question, _keywords));
  }

  void _overrideQuestion() {
    if (_contextController.text.isNotEmpty) {
      context.read<ContextGeneratorBloc>().add(
        OverrideQuestionWithContext(
          questionId: widget.id,
          questionType: widget.type,
          contextualizedQuestion: _contextController.text,
        ),
      );
    }
  }

  void _saveAsNewQuestion() {
    if (_contextController.text.isNotEmpty) {
      Map<String, dynamic> questionData = _getDefaultQuestionData();
      
      context.read<ContextGeneratorBloc>().add(
        SaveAsNewQuestionWithContext(
          questionType: widget.type,
          bankId: "6aa0c742-2920-4556-9c24-8d41c8be1ffb", // Valid bank ID from API examples
          contextualizedQuestion: _contextController.text,
          questionData: questionData,
        ),
      );
    }
  }

  Map<String, dynamic> _getDefaultQuestionData() {
    switch (widget.type.toLowerCase()) {
      case 'mcq':
        return {
          'points': 5,
          'options': ['Option A', 'Option B', 'Option C', 'Option D'],
          'answerIndex': 0,
          'variableIds': [],
        };
      case 'msq':
        return {
          'points': 5,
          'options': ['Option A', 'Option B', 'Option C', 'Option D'],
          'answerIndices': [0],
          'variableIds': [],
        };
      case 'nat':
        return {
          'points': 5,
          'answer': 0.0,
          'variable': [],
        };
      case 'subjective':
        return {
          'points': 10,
          'idealAnswer': '',
          'gradingCriteria': ['Accuracy', 'Completeness', 'Clarity'],
          'variable': [],
        };
      default:
        return {
          'points': 5,
        };
    }
  }

  void _saveQuestion() {
    context.read<ContextGeneratorBloc>().add(SaveQuestion(widget.id, widget.type, _contextController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Context Generation',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Original Question:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(widget.question),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _keywordController,
                      decoration: const InputDecoration(
                        labelText: 'Add Keyword',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a keyword';
                        }
                        return null;
                      },
                      onFieldSubmitted: _addKeyword,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _addKeyword(_keywordController.text),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (_keywords.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                children: _keywords.map((keyword) => Chip(
                  label: Text(keyword),
                  onDeleted: () => _removeKeyword(keyword),
                )).toList(),
              ),
              const SizedBox(height: 20),
              BlocConsumer<ContextGeneratorBloc, ContextGeneratorState>(
                listener: (context, state) {
                  if (state is ContextGeneratorSuccess) {
                    setState(() {
                      _generatedContext = state.response;
                      _contextController.text = _generatedContext;
                    });
                    if (state.response == 'Question updated successfully') {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Question updated successfully')),
                      );
                      // Refresh the question list
                      context.go('/teacher-dashboard/questions');
                    }
                  } else if (state is ContextGeneratorFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.error}')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ContextGeneratorLoading) {
                    return CircularProgressIndicator();
                  } else {
                    return TextField(
                      maxLines: 8,
                      decoration: InputDecoration(
                        labelText: 'Generated Context',
                        border: OutlineInputBorder(),
                      ),
                      controller: _contextController,
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _generateContext,
                    child: Text('Generate Context'),
                  ),
                  ElevatedButton(
                    onPressed: _saveQuestion,
                    child: Text('Save Question'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}