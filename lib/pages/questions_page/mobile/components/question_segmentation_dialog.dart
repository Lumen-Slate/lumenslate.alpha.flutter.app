import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/question_segmentation/question_segmentation_bloc.dart';
import '../../../../blocs/questions/questions_bloc.dart';
import '../../../../models/questions/mcq.dart';
import '../../../../models/questions/msq.dart';
import '../../../../models/questions/nat.dart';
import '../../../../models/questions/subjective.dart';

class QuestionSegmentationDialog extends StatefulWidget {
  final dynamic questionObject;
  final String id;
  final String type;

  const QuestionSegmentationDialog({
    super.key,
    required this.questionObject,
    required this.id,
    required this.type,
  });

  @override
  QuestionSegmentationDialogState createState() => QuestionSegmentationDialogState();
}

class QuestionSegmentationDialogState extends State<QuestionSegmentationDialog> {
  List<String> _segmentedQuestions = [];

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

  void _segmentQuestion() {
    String questionText = _getQuestionText();
    context.read<QuestionSegmentationBloc>().add(SegmentQuestion(questionText));
  }

  void _overrideQuestion() {
    if (_segmentedQuestions.isNotEmpty) {
      context.read<QuestionSegmentationBloc>().add(
        OverrideQuestionWithParts(
          questionId: widget.id,
          questionType: widget.type,
          segmentedQuestions: _segmentedQuestions,
        ),
      );
    }
  }

  void _addQuestion() {
    if (_segmentedQuestions.isNotEmpty) {
      Map<String, dynamic> questionData = _getQuestionDataWithOriginalProperties();
      String bankId = _getBankIdFromOriginalQuestion();
      
      context.read<QuestionSegmentationBloc>().add(
        AddQuestionWithParts(
          questionType: widget.type,
          bankId: bankId,
          segmentedQuestions: _segmentedQuestions,
          questionData: questionData,
        ),
      );
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

  Map<String, dynamic> _getQuestionDataWithOriginalProperties() {
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95, // Increased from 0.9 to 0.95 for more width
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9, // Increased from 0.8 to 0.9 for more height
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Question Segmentation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Original Question:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getQuestionText(),
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocConsumer<QuestionSegmentationBloc, QuestionSegmentationState>(
                  listener: (context, state) {
                    if (state is QuestionSegmentationSuccess) {
                      setState(() {
                        _segmentedQuestions = state.segmentedQuestions;
                      });
                    } else if (state is QuestionSegmentationFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${state.error}')),
                      );
                    } else if (state is QuestionOverrideSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message), backgroundColor: Colors.green),
                      );
                      context.read<QuestionsBloc>().add(const LoadQuestions());
                      Navigator.of(context).pop();
                    } else if (state is QuestionOverrideFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Override failed: ${state.error}'), backgroundColor: Colors.red),
                      );
                    } else if (state is AddQuestionSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message), backgroundColor: Colors.green),
                      );
                      context.read<QuestionsBloc>().add(const LoadQuestions());
                      Navigator.of(context).pop();
                    } else if (state is AddQuestionFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Add question failed: ${state.error}'), backgroundColor: Colors.red),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is QuestionSegmentationLoading) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          const SizedBox(height: 10),
                          Text(
                            'Breaking down your question...',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      );
                    } else if (state is QuestionOverrideLoading) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          const SizedBox(height: 10),
                          Text(
                            'Overriding question...',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      );
                    } else if (state is AddQuestionLoading) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          const SizedBox(height: 10),
                          Text(
                            'Adding new question...',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      );
                    } else if (_segmentedQuestions.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Segmented Questions (${_segmentedQuestions.length}):',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _segmentedQuestions.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue[200]!),
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.blue[50],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          _segmentedQuestions[index],
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
                            Icon(Icons.quiz, size: 40, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text(
                              'Tap "Segment Question" to break this question into smaller parts',
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
                  // Segment button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _segmentQuestion,
                          icon: Icon(Icons.auto_fix_high, size: 18),
                          label: Text('Segment Question', style: TextStyle(fontSize: 14)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Action buttons (shown only when segmented questions are available)
                  if (_segmentedQuestions.isNotEmpty) ...[
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
                            onPressed: _addQuestion,
                            icon: Icon(Icons.add, size: 16),
                            label: Text('Add New', style: TextStyle(fontSize: 12)),
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
                            padding: EdgeInsets.symmetric(vertical: 12),
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
      ),
    );
  }
} 