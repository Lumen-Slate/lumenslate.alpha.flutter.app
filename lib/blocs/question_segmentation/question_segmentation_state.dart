part of 'question_segmentation_bloc.dart';

abstract class QuestionSegmentationState extends Equatable {
  const QuestionSegmentationState();

  @override
  List<Object> get props => [];
}

class QuestionSegmentationInitial extends QuestionSegmentationState {}

class QuestionSegmentationLoading extends QuestionSegmentationState {}

class QuestionSegmentationSuccess extends QuestionSegmentationState {
  final List<String> segmentedQuestions;

  const QuestionSegmentationSuccess(this.segmentedQuestions);

  @override
  List<Object> get props => [segmentedQuestions];
}

class QuestionSegmentationFailure extends QuestionSegmentationState {
  final String error;

  const QuestionSegmentationFailure(this.error);

  @override
  List<Object> get props => [error];
}

class QuestionOverrideLoading extends QuestionSegmentationState {}

class QuestionOverrideSuccess extends QuestionSegmentationState {
  final String message;

  const QuestionOverrideSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class QuestionOverrideFailure extends QuestionSegmentationState {
  final String error;

  const QuestionOverrideFailure(this.error);

  @override
  List<Object> get props => [error];
}

class AddQuestionLoading extends QuestionSegmentationState {}

class AddQuestionSuccess extends QuestionSegmentationState {
  final String message;

  const AddQuestionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AddQuestionFailure extends QuestionSegmentationState {
  final String error;

  const AddQuestionFailure(this.error);

  @override
  List<Object> get props => [error];
}
