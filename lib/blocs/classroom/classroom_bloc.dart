import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../models/classroom.dart';
import '../../models/classroom_extended.dart';
import '../../repositories/classroom_repository.dart';

part 'classroom_event.dart';
part 'classroom_state.dart';

class ClassroomBloc extends Bloc<ClassroomEvent, ClassroomState> {
  final ClassroomRepository repository;

  ClassroomBloc({required this.repository}) : super(ClassroomInitial()) {
    on<FetchNextClassroomPage>((event, emit) async {
      ClassroomState currentState = state;
      if (event.extended) {
        PagingState<int, ClassroomExtended> pagingState = currentState is ClassroomExtendedSuccess
            ? currentState.pagingState
            : PagingState<int, ClassroomExtended>();

        emit(ClassroomExtendedSuccess(pagingState.copyWith(isLoading: true)));

        try {
          final int nextOffset = (pagingState.keys?.last ?? 0) + (pagingState.pages?.lastOrNull?.length ?? 0);
          final response = await repository.getClassrooms(
            teacherId: event.teacherId,
            limit: event.pageSize,
            offset: nextOffset,
            extended: true,
          );

          if (response.statusCode == 200) {
            final List<ClassroomExtended> classrooms = [];
            for (var item in response.data) {
              classrooms.add(ClassroomExtended.fromJson(item));
            }
            final isLastPage = classrooms.length < event.pageSize;

            emit(
              ClassroomExtendedSuccess(
                pagingState.copyWith(
                  pages: [...?pagingState.pages, classrooms],
                  keys: [...?pagingState.keys, nextOffset],
                  hasNextPage: !isLastPage,
                  isLoading: false,
                ),
              ),
            );
          } else {
            emit(ClassroomFailure(Exception('Failed to load classrooms')));
          }
        } catch (error) {
          emit(ClassroomFailure(error));
        }
      } else {
        PagingState<int, Classroom> pagingState = currentState is ClassroomOriginalSuccess
            ? currentState.pagingState
            : PagingState<int, Classroom>();

        emit(ClassroomOriginalSuccess(pagingState.copyWith(isLoading: true)));

        try {
          final int nextOffset = (pagingState.keys?.last ?? 0) + (pagingState.pages?.lastOrNull?.length ?? 0);
          final response = await repository.getClassrooms(
            teacherId: event.teacherId,
            limit: event.pageSize,
            offset: nextOffset,
            extended: false,
          );

          if (response.statusCode == 200) {
            final List<Classroom> classrooms = [];
            for (var item in response.data) {
              classrooms.add(Classroom.fromJson(item));
            }
            final isLastPage = classrooms.length < event.pageSize;

            emit(
              ClassroomOriginalSuccess(
                pagingState.copyWith(
                  pages: [...?pagingState.pages, classrooms],
                  keys: [...?pagingState.keys, nextOffset],
                  hasNextPage: !isLastPage,
                  isLoading: false,
                ),
              ),
            );
          } else {
            emit(ClassroomFailure(Exception('Failed to load classrooms')));
          }
        } catch (error) {
          emit(ClassroomFailure(error));
        }
      }
    });

    on<InitializeClassroomPaging>((event, emit) {
      if (event.extended) {
        emit(ClassroomExtendedSuccess(PagingState<int, ClassroomExtended>(isLoading: true)));
      } else {
        emit(ClassroomOriginalSuccess(PagingState<int, Classroom>(isLoading: true)));
      }
    });

    on<FetchClassroomById>((event, emit) async {
      emit(ClassroomSingleLoading());
      try {
        final response = await repository.getClassroom(id: event.id, extended: event.extended);
        if (response.statusCode == 200) {
          if (event.extended) {
            final classroom = ClassroomExtended.fromJson(response.data);
            emit(ClassroomSingleExtendedSuccess(classroom));
          } else {
            final classroom = Classroom.fromJson(response.data);
            emit(ClassroomSingleOriginalSuccess(classroom));
          }
        } else {
          emit(ClassroomSingleFailure(Exception('Failed to load classroom')));
        }
      } catch (error) {
        emit(ClassroomSingleFailure(error));
      }
    });
  }
}
