import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../repositories/student_classroom_repository.dart';

part 'student_classroom_event.dart';

part 'student_classroom_state.dart';

class StudentClassroomBloc extends Bloc<StudentClassroomEvent, PagingState<int, dynamic>> {
  final StudentClassroomRepository repository;

  StudentClassroomBloc({required this.repository}) : super(PagingState()) {
    on<InitializeStudentClassroomPaging>((event, emit) async {
      emit(PagingState(isLoading: true));
      try {
        final response = await repository.getStudentClassrooms(
          studentId: event.studentId,
          limit: event.pageSize,
          offset: 0,
        );
        if (response.statusCode == 200) {
          final List classrooms = response.data['classrooms'] ?? [];
          final isLastPage = classrooms.length < event.pageSize;
          emit(PagingState<int, dynamic>(pages: [classrooms], keys: [0], hasNextPage: !isLastPage, isLoading: false));
        } else {
          emit(PagingState(error: Exception('Failed to load classrooms'), isLoading: false));
        }
      } catch (error) {
        emit(PagingState(error: error, isLoading: false));
      }
    });

    on<SearchStudentClassrooms>((event, emit) async {
      emit(PagingState(isLoading: true));
      try {
        final response = await repository.getStudentClassrooms(
          studentId: event.studentId,
          limit: event.pageSize,
          offset: 0,
        );
        if (response.statusCode == 200) {
          final List classrooms = response.data['classrooms'] ?? [];
          final isLastPage = classrooms.length < event.pageSize;
          emit(PagingState<int, dynamic>(pages: [classrooms], keys: [0], hasNextPage: !isLastPage, isLoading: false));
        } else {
          emit(PagingState(error: Exception('Failed to search classrooms'), isLoading: false));
        }
      } catch (error) {
        emit(PagingState(error: error, isLoading: false));
      }
    });

    on<FetchNextStudentClassroomPage>((event, emit) async {
      final state = this.state;
      if (state.isLoading || !(state.hasNextPage)) return;

      emit(state.copyWith(isLoading: true, error: null));
      try {
        final int nextOffset = (state.keys?.last ?? 0) + (state.pages?.lastOrNull?.length ?? 0);
        final response = await repository.getStudentClassrooms(
          studentId: event.studentId,
          limit: event.pageSize,
          offset: nextOffset,
        );
        if (response.statusCode == 200) {
          final List classrooms = response.data['classrooms'] ?? [];
          final isLastPage = classrooms.length < event.pageSize;
          emit(
            state.copyWith(
              pages: [...?state.pages, classrooms],
              keys: [...state.keys ?? [], nextOffset],
              hasNextPage: !isLastPage,
              isLoading: false,
            ),
          );
        } else {
          emit(state.copyWith(error: Exception('Failed to load classrooms'), isLoading: false));
        }
      } catch (error) {
        emit(state.copyWith(error: error, isLoading: false));
      }
    });

    on<JoinStudentClassroom>((event, emit) async {
      // emit(StudentClassroomJoining());
      try {
        final response = await repository.joinClassroom(studentId: event.studentId, classroomCode: event.classroomCode);
        if (response.statusCode == 200) {
          // on success refetch the classrooms again
          add(InitializeStudentClassroomPaging(studentId: event.studentId));
          add(SearchStudentClassrooms(studentId: event.studentId));
          // emit(StudentClassroomJoined());
        } else {
          // emit(StudentClassroomError(response.data?['error'] ?? 'Failed to join classroom'));
        }
      } catch (e) {
        // emit(StudentClassroomError(e.toString()));
      }
    });
  }
}
