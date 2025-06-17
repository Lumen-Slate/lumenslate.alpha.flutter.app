import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../models/assignments.dart';
import '../../repositories/assignment_repository.dart';

part 'assignment_event.dart';
part 'assignment_state.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, PagingState<int, Assignment>> {
  final AssignmentRepository repository;

  AssignmentBloc({required this.repository}) : super(PagingState()) {
    on<FetchNextAssignmentPage>((event, emit) async {
      final state = this.state;
      if (state.isLoading || !(state.hasNextPage)) return;

      emit(state.copyWith(isLoading: true, error: null));

      try {
        final int nextOffset = (state.keys?.last ?? 0) + (state.pages?.lastOrNull?.length ?? 0);
        final response = await repository.getAssignments(
          teacherId: event.teacherId,
          limit: 10,
          offset: 0,
        );


        if (response.statusCode == 200) {
          final List<Assignment> assignments = [];
          for (var item in response.data) {
            assignments.add(Assignment.fromJson(item));
          }
          final isLastPage = assignments.length < event.pageSize;

          emit(
            state.copyWith(
              pages: [...?state.pages, assignments],
              keys: [...state.keys ?? [], nextOffset],
              hasNextPage: !isLastPage,
              isLoading: false,
            ),
          );
        } else {
          emit(state.copyWith(error: Exception('Failed to load assignments'), isLoading: false));
        }
      } catch (error) {
        emit(state.copyWith(error: error, isLoading: false));
      }
    });
  }
}
