part of 'question_bank_bloc.dart';

@immutable
sealed class QuestionBankEvent {}

final class FetchNextQuestionBankPage extends QuestionBankEvent {}
