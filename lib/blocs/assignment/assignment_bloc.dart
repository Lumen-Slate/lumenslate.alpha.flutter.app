import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../models/assignments.dart';
import '../../models/extended/assignment_extended.dart';
import '../../repositories/assignment_repository.dart';

part 'assignment_event.dart';
part 'assignment_state.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  final AssignmentRepository repository;

  AssignmentBloc({required this.repository}) : super(AssignmentInitial()) {
    on<FetchNextAssignmentPage>((event, emit) async {
      AssignmentState currentState = state;
      if (event.extended) {
        PagingState<int, AssignmentExtended> pagingState = currentState is AssignmentExtendedSuccess
            ? currentState.pagingState
            : PagingState<int, AssignmentExtended>();


         emit(AssignmentExtendedSuccess(pagingState.copyWith(isLoading: true)));

        try {
          final int nextOffset = (pagingState.keys?.last ?? 0) + (pagingState.pages?.lastOrNull?.length ?? 0);
          final response = await repository.getAssignments(
            teacherId: event.teacherId,
            limit: event.pageSize,
            offset: nextOffset,
            extended: true,
            searchQuery: event.searchQuery,
          );

          if (response.statusCode == 200) {
            final List<AssignmentExtended> assignments = [];
            for (var item in response.data) {
              assignments.add(AssignmentExtended.fromJson(item));
            }
            final isLastPage = assignments.length < event.pageSize;

            emit(
              AssignmentExtendedSuccess(
                pagingState.copyWith(
                  pages: [...?pagingState.pages, assignments],
                  keys: [...?pagingState.keys, nextOffset],
                  hasNextPage: !isLastPage,
                  isLoading: false,
                ),
              ),
            );
          } else {
            emit(AssignmentFailure(Exception('Failed to load assignments')));
          }
        } catch (error) {
          emit(AssignmentFailure(error));
        }
      } else {
        PagingState<int, Assignment> pagingState = currentState is AssignmentOriginalSuccess
            ? currentState.pagingState
            : PagingState<int, Assignment>();
        
        emit(AssignmentOriginalSuccess(pagingState.copyWith(isLoading: true)));

        try {
          final int nextOffset = (pagingState.keys?.last ?? 0) + (pagingState.pages?.lastOrNull?.length ?? 0);
          final response = await repository.getAssignments(
            teacherId: event.teacherId,
            limit: event.pageSize,
            offset: nextOffset,
            extended: false,
            searchQuery: event.searchQuery,
          );

          if (response.statusCode == 200) {
            final List<Assignment> assignments = [];
            for (var item in response.data) {
              assignments.add(Assignment.fromJson(item));
            }
            final isLastPage = assignments.length < event.pageSize;

            emit(
              AssignmentOriginalSuccess(
                pagingState.copyWith(
                  pages: [...?pagingState.pages, assignments],
                  keys: [...?pagingState.keys, nextOffset],
                  hasNextPage: !isLastPage,
                  isLoading: false,
                ),
              ),
            );
          } else {
            emit(AssignmentFailure(Exception('Failed to load assignments')));
          }
        } catch (error) {
          emit(AssignmentFailure(error));
        }
      }
    });
    on<InitializeAssignmentPaging>((event, emit) async {
      if (event.extended) {
        emit(AssignmentExtendedSuccess(PagingState<int, AssignmentExtended>(isLoading: true)));
        
        try {
          final response = await repository.getAssignments(
            teacherId: event.teacherId,
            limit: 3,
            offset: 0,
            extended: true,
          );
          
          if (response.statusCode == 200) {
            final List<AssignmentExtended> assignments = [];
            for (var item in response.data) {
              assignments.add(AssignmentExtended.fromJson(item));
            }
            final isLastPage = assignments.length < 3;

            emit(
              AssignmentExtendedSuccess(
                PagingState<int, AssignmentExtended>(
                  pages: [assignments],
                  keys: [0],
                  hasNextPage: !isLastPage,
                  isLoading: false,
                ),
              ),
            );
          } else {
            emit(AssignmentFailure(Exception('Failed to load assignments')));
          }
        } catch (error) {
          emit(AssignmentFailure(error));
        }
      } else {
        emit(AssignmentOriginalSuccess(PagingState<int, Assignment>(isLoading: true)));
        
        try {
          final response = await repository.getAssignments(
            teacherId: event.teacherId,
            limit: 3,
            offset: 0,
            extended: false,
          );
          
          if (response.statusCode == 200) {
            final List<Assignment> assignments = [];
            for (var item in response.data) {
              assignments.add(Assignment.fromJson(item));
            }
            final isLastPage = assignments.length < 3;

            emit(
              AssignmentOriginalSuccess(
                PagingState<int, Assignment>(
                  pages: [assignments],
                  keys: [0],
                  hasNextPage: !isLastPage,
                  isLoading: false,
                ),
              ),
            );
          } else {
            emit(AssignmentFailure(Exception('Failed to load assignments')));
          }
        } catch (error) {
          emit(AssignmentFailure(error));
        }
      }
    });
    on<SearchAssignments>((event, emit) async {
      // Reset to a fresh paging state for search
      if (event.extended) {
        emit(AssignmentExtendedSuccess(PagingState<int, AssignmentExtended>(isLoading: true)));
        
        try {
          final response = await repository.getAssignments(
            teacherId: event.teacherId,
            limit: 3,
            offset: 0,
            extended: true,
            searchQuery: event.searchQuery,
          );

          if (response.statusCode == 200) {
            final List<AssignmentExtended> assignments = [];
            for (var item in response.data) {
              assignments.add(AssignmentExtended.fromJson(item));
            }
            final isLastPage = assignments.length < 3;

            emit(
              AssignmentExtendedSuccess(
                PagingState<int, AssignmentExtended>(
                  pages: [assignments],
                  keys: [0],
                  hasNextPage: !isLastPage,
                  isLoading: false,
                ),
              ),
            );
          } else {
            emit(AssignmentFailure(Exception('Failed to search assignments')));
          }
        } catch (error) {
          emit(AssignmentFailure(error));
        }
      } else {
        emit(AssignmentOriginalSuccess(PagingState<int, Assignment>(isLoading: true)));
        
        try {
          final response = await repository.getAssignments(
            teacherId: event.teacherId,
            limit: 3,
            offset: 0,
            extended: false,
            searchQuery: event.searchQuery,
          );

          if (response.statusCode == 200) {
            final List<Assignment> assignments = [];
            for (var item in response.data) {
              assignments.add(Assignment.fromJson(item));
            }
            final isLastPage = assignments.length < 3;

            emit(
              AssignmentOriginalSuccess(
                PagingState<int, Assignment>(
                  pages: [assignments],
                  keys: [0],
                  hasNextPage: !isLastPage,
                  isLoading: false,
                ),
              ),
            );
          } else {
            emit(AssignmentFailure(Exception('Failed to search assignments')));
          }
        } catch (error) {
          emit(AssignmentFailure(error));
        }
      }
    });
    on<FetchAssignmentById>((event, emit) async {
      emit(AssignmentSingleLoading());
      try {
        final response = await repository.getAssignment(id: event.id, extended: event.extended);
        if (response.statusCode == 200) {
          if (event.extended) {
            final assignment = AssignmentExtended.fromJson(response.data);
            emit(AssignmentSingleExtendedSuccess(assignment));
          } else {
            final assignment = Assignment.fromJson(response.data);
            emit(AssignmentSingleOriginalSuccess(assignment));
          }
        } else {
          emit(AssignmentSingleFailure(Exception('Failed to load assignment')));
        }
      } catch (error) {
        emit(AssignmentSingleFailure(error));
      }
    });
  }
}