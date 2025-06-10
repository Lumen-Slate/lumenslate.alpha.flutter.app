part of 'questions_bloc.dart';

abstract class QuestionsEvent extends Equatable {
  const QuestionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuestions extends QuestionsEvent {
  final String? bankId;
  final int limit;
  final int offset;

  const LoadQuestions({
    this.bankId,
    this.limit = 100,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [bankId, limit, offset];
}

class QuestionsReset extends QuestionsEvent {} 