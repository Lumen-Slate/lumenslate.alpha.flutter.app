import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/context_generation/context_generation_bloc.dart';
import '../../../../blocs/questions/questions_bloc.dart';

class ContextGenerationDialogMobile extends StatefulWidget {
  final String question;
  final String id;
  final String type;

  const ContextGenerationDialogMobile({
    super.key,
    required this.question,
    required this.id,
    required this.type,
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
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.85, // Limit dialog height
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - Fixed at top
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Context Generation',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Original Question:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(widget.question),
                    ),
                    const SizedBox(height: 16),
                    
                    // Keywords section
                    Text(
                      'Keywords (help AI generate better context):',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _keywordController,
                            decoration: const InputDecoration(
                              labelText: 'Add Keyword',
                              hintText: 'e.g., algorithm, complexity',
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
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _addKeyword(_keywordController.text),
                              child: const Text('Add Keyword'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_keywords.isNotEmpty) ...[
                      Wrap(
                        spacing: 6,
                        children: _keywords.map((keyword) => Chip(
                          label: Text(keyword, style: const TextStyle(fontSize: 12)),
                          onDeleted: () => _removeKeyword(keyword),
                          visualDensity: VisualDensity.compact,
                        )).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Context generation section
                    BlocConsumer<ContextGeneratorBloc, ContextGeneratorState>(
                      listener: (context, state) {
                        if (state is ContextGeneratorSuccess) {
                          setState(() {
                            _generatedContext = state.response;
                            _contextController.text = _generatedContext;
                          });
                        } else if (state is ContextGeneratorFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${state.error}')),
                          );
                        } else if (state is ContextOverrideSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message), backgroundColor: Colors.green),
                          );
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
                          context.read<QuestionsBloc>().add(const LoadQuestions());
                          Navigator.of(context).pop();
                        } else if (state is ContextSaveAsNewFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Save failed: ${state.error}'), backgroundColor: Colors.red),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is ContextGeneratorLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 10),
                                  Text(
                                    'Generating context...',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (state is ContextOverrideLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 10),
                                  Text(
                                    'Overriding question...',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (state is ContextSaveAsNewLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 10),
                                  Text(
                                    'Saving new question...',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (_contextController.text.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Generated Context:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 120, // Fixed height for mobile
                                child: TextField(
                                  maxLines: null,
                                  expands: true,
                                  controller: _contextController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    alignLabelWithHint: true,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: _overrideQuestion,
                                      icon: const Icon(Icons.update),
                                      label: const Text('Override Current Question'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: _saveAsNewQuestion,
                                      icon: const Icon(Icons.add),
                                      label: const Text('Save as New Question'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                        
                        return SizedBox(
                          height: 120, // Fixed height for mobile
                          child: TextField(
                            maxLines: null,
                            expands: true,
                            controller: _contextController,
                            decoration: const InputDecoration(
                              labelText: 'Generated Context',
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Fixed bottom section
            const SizedBox(height: 16),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _generateContext,
                    child: const Text('Generate Context'),
                  ),
                ),
                if (_contextController.text.isEmpty) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveQuestion,
                      child: const Text('Save Question'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
