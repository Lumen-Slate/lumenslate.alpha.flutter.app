import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../models/students.dart';
import '../../repositories/student_repository.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository repository;

  StudentBloc({required this.repository}) : super(StudentInitial()) {
    on<FetchNextStudentPage>((event, emit) async {
      StudentState currentState = state;
      // if (event.extended) {
      //   PagingState<int, StudentExtended> pagingState = currentState is StudentExtendedSuccess
      //       ? currentState.pagingState
      //       : PagingState<int, StudentExtended>();
      //
      //   emit(StudentExtendedSuccess(pagingState.copyWith(isLoading: true)));
      //
      //   try {
      //     final int nextOffset = (pagingState.keys?.last ?? 0) + (pagingState.pages?.lastOrNull?.length ?? 0);
      //     final response = await repository.getStudents(
      //       limit: event.pageSize,
      //       offset: nextOffset,
      //       extended: true,
      //     );
      //
      //     if (response.statusCode == 200) {
      //       final List<StudentExtended> students = [];
      //       for (var item in response.data) {
      //         students.add(StudentExtended.fromJson(item));
      //       }
      //       final isLastPage = students.length < event.pageSize;
      //
      //       emit(
      //         StudentExtendedSuccess(
      //           pagingState.copyWith(
      //             pages: [...?pagingState.pages, students],
      //             keys: [...?pagingState.keys, nextOffset],
      //             hasNextPage: !isLastPage,
      //             isLoading: false,
      //           ),
      //         ),
      //       );
      //     } else {
      //       emit(StudentFailure(Exception('Failed to load students')));
      //     }
      //   } catch (error) {
      //     emit(StudentFailure(error));
      //   }
      // } else {
        PagingState<int, Student> pagingState = currentState is StudentOriginalSuccess
            ? currentState.pagingState
            : PagingState<int, Student>();

        emit(StudentOriginalSuccess(pagingState.copyWith(isLoading: true)));

        try {
          final int nextOffset = (pagingState.keys?.last ?? 0) + (pagingState.pages?.lastOrNull?.length ?? 0);
          final response = await repository.getStudents(
            limit: event.pageSize,
            offset: nextOffset,
            extended: false,
          );

          if (response.statusCode == 200) {
            final List<Student> students = [];
            for (var item in response.data) {
              students.add(Student.fromJson(item));
            }
            final isLastPage = students.length < event.pageSize;

            emit(
              StudentOriginalSuccess(
                pagingState.copyWith(
                  pages: [...?pagingState.pages, students],
                  keys: [...?pagingState.keys, nextOffset],
                  hasNextPage: !isLastPage,
                  isLoading: false,
                ),
              ),
            );
          } else {
            emit(StudentFailure(Exception('Failed to load students')));
          }
        } catch (error) {
          emit(StudentFailure(error));
        }
      // }
    });

    on<InitializeStudentPaging>((event, emit) {
      // if (event.extended) {
      //   emit(StudentExtendedSuccess(PagingState<int, StudentExtended>(isLoading: true)));
      // } else {
        emit(StudentOriginalSuccess(PagingState<int, Student>(isLoading: true)));
      // }
    });

    on<FetchStudentById>((event, emit) async {
      emit(StudentSingleLoading());
      try {
        final response = await repository.getStudent(id: event.id, extended: event.extended);
        if (response.statusCode == 200) {
          // if (event.extended) {
          //   final student = StudentExtended.fromJson(response.data);
          //   emit(StudentSingleExtendedSuccess(student));
          // } else {
            final student = Student.fromJson(response.data);
            emit(StudentSingleOriginalSuccess(student));
          // }
        } else {
          emit(StudentSingleFailure(Exception('Failed to load student')));
        }
      } catch (error) {
        emit(StudentSingleFailure(error));
      }
    });
  }
}
