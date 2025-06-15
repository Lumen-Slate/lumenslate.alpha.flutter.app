part of 'question_bank_bloc.dart';

@immutable
sealed class QuestionBankEvent {}

final class FetchNextQuestionBankPage extends QuestionBankEvent {
  final String teacherId;
  final int pageSize;

  FetchNextQuestionBankPage({
    required this.teacherId,
    this.pageSize = 3,
  });
}
