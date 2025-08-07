part of 'question_bank_bloc.dart';

@immutable
sealed class QuestionBankEvent {}

final class InitializeQuestionBankPaging extends QuestionBankEvent {
  final String teacherId;

  InitializeQuestionBankPaging({required this.teacherId});
}

final class FetchNextQuestionBankPage extends QuestionBankEvent {
  final String teacherId;
  final int pageSize;
  final String? searchQuery;

  FetchNextQuestionBankPage({
    required this.teacherId,
    this.pageSize = 3,
    this.searchQuery,
  });
}

final class SearchQuestionBanks extends QuestionBankEvent {
  final String teacherId;
  final String searchQuery;
  final int pageSize;

  SearchQuestionBanks({
    required this.teacherId,
    required this.searchQuery,
    this.pageSize = 3,
  });
}
