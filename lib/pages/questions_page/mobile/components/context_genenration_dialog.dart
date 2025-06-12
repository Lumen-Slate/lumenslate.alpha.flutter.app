import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/context_generation/context_generation_bloc.dart';
import '../../../../blocs/questions/questions_bloc.dart';

class ContextGenerationDialogMobile extends StatefulWidget {
  final dynamic question;
  final String type;
  final String id;

  const ContextGenerationDialogMobile({
    super.key,
    required this.question,
    required this.type,
    required this.id,
  });

  @override
  State<ContextGenerationDialogMobile> createState() => _ContextGenerationDialogMobileState();
}

class _ContextGenerationDialogMobileState extends State<ContextGenerationDialogMobile> {
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
    context.read<ContextGeneratorBloc>().add(GenerateContext(widget.question.toString(), _keywords));
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
          'AnswerIndex': 0,
          'variableIds': [],
        };
      case 'msq':
        return {
          'points': 5,
          'options': ['Option A', 'Option B', 'Option C', 'Option D'],
          'AnswerIndices': [0],
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
          'idealAnswer': 'Default ideal answer',
          'gradingCriteria': ['Default grading criteria'],
          'variable': [],
        };
      default:
        return {
          'points': 5,
          'variableIds': [],
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Context Generation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.question.toString(),
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _keywordController,
                decoration: InputDecoration(
                  labelText: 'Enter keyword',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _addKeyword(_keywordController.text),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Keyword cannot be empty';
                  }
                  return null;
                },
                onFieldSubmitted: (value) => _addKeyword(value),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6.0,
              children: _keywords.map((keyword) => Chip(
                label: Text(keyword, style: TextStyle(fontSize: 12)),
                onDeleted: () => _removeKeyword(keyword),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )).toList(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocConsumer<ContextGeneratorBloc, ContextGeneratorState>(
                listener: (context, state) {
                  if (state is ContextGeneratorSuccess && state.response != 'Question updated successfully') {
                    setState(() {
                      _generatedContext = state.response;
                      _contextController.text = _generatedContext;
                    });
                  } else if (state is ContextOverrideSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: Colors.green),
                    );
                    // Refresh questions list
                    context.read<QuestionsBloc>().add(const LoadQuestions());
                    Navigator.of(context).pop();
                  } else if (state is ContextOverrideFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Override failed: ${state.error}'), backgroundColor: Colors.red),
                    );
                  } else if (state is ContextSaveAsNewSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: Colors.green),
                    );
                    // Refresh questions list
                    context.read<QuestionsBloc>().add(const LoadQuestions());
                    Navigator.of(context).pop();
                  } else if (state is ContextSaveAsNewFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Save failed: ${state.error}'), backgroundColor: Colors.red),
                    );
                  } else if (state is ContextGeneratorFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.error}'), backgroundColor: Colors.red),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ContextGeneratorLoading) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        const SizedBox(height: 8),
                        Text('Generating context...', style: TextStyle(fontSize: 12)),
                      ],
                    );
                  } else if (state is ContextOverrideLoading) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        const SizedBox(height: 8),
                        Text('Overriding question...', style: TextStyle(fontSize: 12)),
                      ],
                    );
                  } else if (state is ContextSaveAsNewLoading) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        const SizedBox(height: 8),
                        Text('Saving new question...', style: TextStyle(fontSize: 12)),
                      ],
                    );
                  } else if (_generatedContext.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generated Context:',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: TextField(
                            maxLines: null,
                            expands: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(8),
                            ),
                            controller: _contextController,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lightbulb_outline, size: 40, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text(
                            'Add keywords and tap "Generate Context"',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                // Main generation button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _generateContext,
                        icon: Icon(Icons.lightbulb_outline, size: 18),
                        label: Text('Generate Context', style: TextStyle(fontSize: 14)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Action buttons (shown only when context is generated)
                if (_generatedContext.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _overrideQuestion,
                          icon: Icon(Icons.edit, size: 16),
                          label: Text('Override', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _saveAsNewQuestion,
                          icon: Icon(Icons.add, size: 16),
                          label: Text('Save as New', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                
                const SizedBox(height: 12),
                // Close button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Close', style: TextStyle(fontSize: 14)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
