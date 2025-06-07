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
