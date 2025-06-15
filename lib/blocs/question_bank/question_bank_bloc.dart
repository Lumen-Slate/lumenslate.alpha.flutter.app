import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../repositories/question_bank_repository.dart';
import '../../models/question_bank.dart';

part 'question_bank_event.dart';
part 'question_bank_state.dart';

class QuestionBankBloc extends Bloc<QuestionBankEvent, PagingState<int, QuestionBank>> {
  final QuestionBankRepository repository;

  QuestionBankBloc({required this.repository}) : super(PagingState()) {
    on<FetchNextQuestionBankPage>((event, emit) async {
      final state = this.state;
      if (state.isLoading || !(state.hasNextPage)) return;

      emit(state.copyWith(isLoading: true, error: null));

      try {
        final int nextOffset = (state.keys?.last ?? 0) + (state.pages?.lastOrNull?.length ?? 0);
        final response = await repository.getQuestionBanks(
          teacherId: event.teacherId,
          limit: event.pageSize,
          offset: nextOffset,
        );
        if (response.statusCode == 200) {
          final List data = response.data;
          final banks = data.map((e) => QuestionBank.fromJson(e)).toList().cast<QuestionBank>();
          final isLastPage = banks.length < event.pageSize;

          emit(
            state.copyWith(
              pages: [...?state.pages, banks],
              keys: [...state.keys ?? [], nextOffset],
              hasNextPage: !isLastPage,
              isLoading: false,
            ),
          );
        } else {
          emit(state.copyWith(error: Exception('Failed to load question banks'), isLoading: false));
        }
      } catch (error) {
        emit(state.copyWith(error: error, isLoading: false));
      }
    });
  }
}
