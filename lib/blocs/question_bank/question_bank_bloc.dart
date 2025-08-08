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
    on<InitializeQuestionBankPaging>((event, emit) async {
      emit(PagingState(isLoading: true));
      
      try {
        final response = await repository.getQuestionBanks(
          teacherId: event.teacherId,
          limit: 3,
          offset: 0,
        );
        
        if (response.statusCode == 200) {
          final List data = response.data;
          final banks = data.map((e) => QuestionBank.fromJson(e)).toList().cast<QuestionBank>();
          final isLastPage = banks.length < 3;

          emit(
            PagingState<int, QuestionBank>(
              pages: [banks],
              keys: [0],
              hasNextPage: !isLastPage,
              isLoading: false,
            ),
          );
        } else {
          emit(PagingState(error: Exception('Failed to load question banks'), isLoading: false));
        }
      } catch (error) {
        emit(PagingState(error: error, isLoading: false));
      }
    });

    on<SearchQuestionBanks>((event, emit) async {
      // Reset to a fresh paging state for search
      print('QuestionBankBloc: Starting search with query: "${event.searchQuery}"'); // Debug print
      emit(PagingState(isLoading: true));
      
      try {
        final response = await repository.getQuestionBanks(
          teacherId: event.teacherId,
          limit: event.pageSize,
          offset: 0,
          searchQuery: event.searchQuery,
        );

        if (response.statusCode == 200) {
          final List data = response.data;
          final banks = data.map((e) => QuestionBank.fromJson(e)).toList().cast<QuestionBank>();
          print('QuestionBankBloc: Search returned ${banks.length} results'); // Debug print
          final isLastPage = banks.length < event.pageSize;

          emit(
            PagingState<int, QuestionBank>(
              pages: [banks],
              keys: [0],
              hasNextPage: !isLastPage,
              isLoading: false,
            ),
          );
        } else {
          emit(PagingState(error: Exception('Failed to search question banks'), isLoading: false));
        }
      } catch (error) {
        emit(PagingState(error: error, isLoading: false));
      }
    });

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
          searchQuery: event.searchQuery,
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
