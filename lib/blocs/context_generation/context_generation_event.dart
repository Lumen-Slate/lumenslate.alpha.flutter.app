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

class SaveQuestion extends ContextGeneratorEvent {
  final String id;
  final String type;
  final String updatedQuestion;

  const SaveQuestion(this.id, this.type, this.updatedQuestion);

  @override
  List<Object> get props => [id, type, updatedQuestion];
}