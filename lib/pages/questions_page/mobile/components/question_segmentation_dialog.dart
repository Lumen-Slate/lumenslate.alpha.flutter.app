import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/question_segmentation/question_segmentation_bloc.dart';

class QuestionSegmentationDialog extends StatefulWidget {
  final String question;
  final String id;
  final String type;

  const QuestionSegmentationDialog({
    super.key,
    required this.question,
    required this.id,
    required this.type,
  });

  @override
  QuestionSegmentationDialogState createState() => QuestionSegmentationDialogState();
}

class QuestionSegmentationDialogState extends State<QuestionSegmentationDialog> {
  List<String> _segmentedQuestions = [];

  void _segmentQuestion() {
    context.read<QuestionSegmentationBloc>().add(SegmentQuestion(widget.question));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
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
                      widget.question,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _segmentQuestion,
                      icon: Icon(Icons.auto_fix_high, size: 18),
                      label: Text('Segment', style: TextStyle(fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
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
        ),
      ),
    );
  }
} 