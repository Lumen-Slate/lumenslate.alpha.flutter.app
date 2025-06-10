part of 'question_segmentation_bloc.dart';

abstract class QuestionSegmentationEvent extends Equatable {
  const QuestionSegmentationEvent();

  @override
  List<Object> get props => [];
}

class SegmentQuestion extends QuestionSegmentationEvent {
  final String question;

  const SegmentQuestion(this.question);

  @override
  List<Object> get props => [question];
}

class QuestionSegmentationReset extends QuestionSegmentationEvent {
  const QuestionSegmentationReset();

  @override
  List<Object> get props => [];
}

class OverrideQuestionWithParts extends QuestionSegmentationEvent {
  final String questionId;
  final String questionType;
  final List<String> segmentedQuestions;

  const OverrideQuestionWithParts({
    required this.questionId,
    required this.questionType,
    required this.segmentedQuestions,
  });

  @override
  List<Object> get props => [questionId, questionType, segmentedQuestions];
}

class AddQuestionWithParts extends QuestionSegmentationEvent {
  final String questionType;
  final String bankId;
  final List<String> segmentedQuestions;
  final Map<String, dynamic> questionData;

  const AddQuestionWithParts({
    required this.questionType,
    required this.bankId,
    required this.segmentedQuestions,
    required this.questionData,
  });

  @override
  List<Object> get props => [questionType, bankId, segmentedQuestions, questionData];
}
