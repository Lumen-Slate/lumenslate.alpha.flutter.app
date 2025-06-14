import 'package:lumen_slate/lib.dart';

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
    return ResponsiveScaledBox(
      width: AppConstants.desktopScaleWidth,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85, // 85% of screen width, more responsive
          height: MediaQuery.of(context).size.height * 0.9, // 90% of screen height for more space
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Question Segmentation',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[50],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Original Question:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getQuestionText(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
                        // Refresh questions list
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
                        // Refresh questions list
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
                            Text('Breaking down your question...'),
                          ],
                        );
                      } else if (state is QuestionOverrideLoading) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            const SizedBox(height: 10),
                            Text('Overriding question...'),
                          ],
                        );
                      } else if (state is AddQuestionLoading) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            const SizedBox(height: 10),
                            Text('Adding new question...'),
                          ],
                        );
                      } else if (_segmentedQuestions.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Segmented Questions (${_segmentedQuestions.length}):',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _segmentedQuestions.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue[200]!),
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.blue[50],
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            _segmentedQuestions[index],
                                            style: TextStyle(fontSize: 14),
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
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.quiz, size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 10),
                              Text(
                                'Click "Segment Question" to break this question into smaller parts',
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
                    // Main segmentation button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _segmentQuestion,
                          icon: Icon(Icons.auto_fix_high),
                          label: Text('Segment Question'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Action buttons (shown only when segmented questions are available)
                    if (_segmentedQuestions.isNotEmpty) ...[
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
                            onPressed: _addQuestion,
                            icon: Icon(Icons.add),
                            label: Text('Add Question'),
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