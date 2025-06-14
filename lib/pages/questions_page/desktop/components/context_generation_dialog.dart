import 'package:lumen_slate/lib.dart';

import '../../../../models/questions/mcq.dart';
import '../../../../models/questions/msq.dart';
import '../../../../models/questions/nat.dart';
import '../../../../models/questions/subjective.dart';

class ContextGenerationDialog extends StatefulWidget {
  final dynamic questionObject;
  final String id;
  final String type;

  const ContextGenerationDialog({
    super.key,
    required this.questionObject,
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
    String questionText = _getQuestionText();
    context.read<ContextGeneratorBloc>().add(GenerateContext(questionText, _keywords));
  }

  String _getQuestionText() {
    switch (widget.questionObject.runtimeType) {
      case MCQ:
        return (widget.questionObject as MCQ).question;
      case MSQ:
        return (widget.questionObject as MSQ).question;
      case NAT:
        return (widget.questionObject as NAT).question;
      case Subjective:
        return (widget.questionObject as Subjective).question;
      default:
        return widget.questionObject.toString();
    }
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
      Map<String, dynamic> questionData = _getQuestionDataWithOriginalOptions();
      String bankId = _getBankIdFromOriginalQuestion();
      
      context.read<ContextGeneratorBloc>().add(
        SaveAsNewQuestionWithContext(
          questionType: widget.type,
          bankId: bankId,
          contextualizedQuestion: _contextController.text,
          questionData: questionData,
        ),
      );
    }
  }

  Map<String, dynamic> _getQuestionDataWithOriginalOptions() {
    switch (widget.questionObject.runtimeType) {
      case MCQ:
        final mcq = widget.questionObject as MCQ;
        return {
          'variableIds': mcq.variableIds,
          'points': mcq.points,
          'options': mcq.options, // Use original options
          'answerIndex': mcq.answerIndex,
        };
      case MSQ:
        final msq = widget.questionObject as MSQ;
        return {
          'variableIds': msq.variableIds,
          'points': msq.points,
          'options': msq.options, // Use original options
          'answerIndices': msq.answerIndices,
        };
      case NAT:
        final nat = widget.questionObject as NAT;
        return {
          'variableIds': nat.variableIds,
          'points': nat.points,
          'answer': nat.answer,
        };
      case Subjective:
        final subjective = widget.questionObject as Subjective;
        return {
          'variableIds': subjective.variableIds,
          'points': subjective.points,
          'idealAnswer': subjective.idealAnswer,
          'gradingCriteria': subjective.gradingCriteria,
        };
      default:
        return {
          'points': 5,
          'variableIds': [],
        };
    }
  }

  String _getBankIdFromOriginalQuestion() {
    switch (widget.questionObject.runtimeType) {
      case MCQ:
        return (widget.questionObject as MCQ).bankId;
      case MSQ:
        return (widget.questionObject as MSQ).bankId;
      case NAT:
        return (widget.questionObject as NAT).bankId;
      case Subjective:
        return (widget.questionObject as Subjective).bankId;
      default:
        return ''; // Fallback, though this should not happen
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: AppConstants.desktopScaleWidth,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: 800,
          height: 700,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Context Generation',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _getQuestionText(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  children: _keywords.map((keyword) => Chip(
                    label: Text(keyword),
                    onDeleted: () => _removeKeyword(keyword),
                  )).toList(),
                ),
                const SizedBox(height: 20),
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
                          const SizedBox(height: 10),
                          Text('Generating context...'),
                        ],
                      );
                    } else if (state is ContextOverrideLoading) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            const SizedBox(height: 10),
                            Text('Overriding question...'),
                          ],
                        );
                      } else if (state is ContextSaveAsNewLoading) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            const SizedBox(height: 10),
                            Text('Saving new question...'),
                          ],
                        );
                      } else if (_generatedContext.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Generated Context:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: TextField(
                                maxLines: null,
                                expands: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(12),
                                ),
                                controller: _contextController,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lightbulb_outline, size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 10),
                              Text(
                                'Add keywords and click "Generate Context" to create contextualized question',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    // Main generation button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _generateContext,
                          icon: Icon(Icons.lightbulb_outline),
                          label: Text('Generate Context'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Action buttons (shown only when context is generated)
                    if (_generatedContext.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _overrideQuestion,
                            icon: Icon(Icons.edit),
                            label: Text('Override Question'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _saveAsNewQuestion,
                            icon: Icon(Icons.add),
                            label: Text('Save as New'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          ),
                          child: Text('Close'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}