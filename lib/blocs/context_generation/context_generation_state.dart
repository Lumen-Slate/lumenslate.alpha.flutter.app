part of 'context_generation_bloc.dart';


abstract class ContextGeneratorState extends Equatable {
  const ContextGeneratorState();

  @override
  List<Object> get props => [];
}

class ContextGeneratorInitial extends ContextGeneratorState {}

class ContextGeneratorLoading extends ContextGeneratorState {}

class ContextGeneratorSuccess extends ContextGeneratorState {
  final String response;

  const ContextGeneratorSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class ContextGeneratorFailure extends ContextGeneratorState {
  final String error;

  const ContextGeneratorFailure(this.error);

  @override
  List<Object> get props => [error];
}

class QuestionOverrideLoading extends ContextGeneratorState {}

class QuestionOverrideSuccess extends ContextGeneratorState {
  final String message;

  const QuestionOverrideSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class QuestionOverrideFailure extends ContextGeneratorState {
  final String error;

  const QuestionOverrideFailure(this.error);

  @override
  List<Object> get props => [error];
}

class SaveAsNewQuestionLoading extends ContextGeneratorState {}

class SaveAsNewQuestionSuccess extends ContextGeneratorState {
  final String message;

  const SaveAsNewQuestionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class SaveAsNewQuestionFailure extends ContextGeneratorState {
  final String error;

  const SaveAsNewQuestionFailure(this.error);

  @override
  List<Object> get props => [error];
}