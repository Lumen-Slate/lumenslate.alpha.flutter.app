part of 'context_generation_bloc.dart';

abstract class ContextGeneratorEvent extends Equatable {
  const ContextGeneratorEvent();

  @override
  List<Object> get props => [];
}

class GenerateContext extends ContextGeneratorEvent {
  final String question;
  final List<String> keywords;

  const GenerateContext(this.question, this.keywords);

  @override
  List<Object> get props => [question, keywords];
}

class ContextGeneratorReset extends ContextGeneratorEvent {
  const ContextGeneratorReset();

  @override
  List<Object> get props => [];
}

class OverwriteQuestionWithContext extends ContextGeneratorEvent {
  final String questionId;
  final String questionType;
  final String contextualizedQuestion;

  const OverwriteQuestionWithContext({
    required this.questionId,
    required this.questionType,
    required this.contextualizedQuestion,
  });

  @override
  List<Object> get props => [questionId, questionType, contextualizedQuestion];
}

class SaveAsNewQuestionWithContext extends ContextGeneratorEvent {
  final String questionType;
  final String bankId;
  final String contextualizedQuestion;
  final Map<String, dynamic> questionData;

  const SaveAsNewQuestionWithContext({
    required this.questionType,
    required this.bankId,
    required this.contextualizedQuestion,
    required this.questionData,
  });

  @override
  List<Object> get props => [questionType, bankId, contextualizedQuestion, questionData];
}