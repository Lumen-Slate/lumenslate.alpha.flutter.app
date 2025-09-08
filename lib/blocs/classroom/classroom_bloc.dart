import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/classroom.dart';
import '../../models/extended/classroom_extended.dart';
import '../../repositories/classroom_repository.dart';

part 'classroom_event.dart';
part 'classroom_state.dart';

class ClassroomBloc extends Bloc<ClassroomEvent, ClassroomState> {
  final ClassroomRepository repository;

  ClassroomBloc({required this.repository}) : super(ClassroomInitial()) {
    /// Create a new classroom
    on<CreateClassroom>((event, emit) async {
      emit(ClassroomSingleLoading());
      try {
        final teacherId = event.teacherId;
        if (event.classroom.name.isEmpty || teacherId.isEmpty) {
          emit(
            ClassroomFailure(
              Exception('Name, teacherId, and credits are required'),
            ),
          );
          return;
        }
        final classroomWithTeacher = Classroom(
          id: event.classroom.id,
          name: event.classroom.name,
          teacherIds: [teacherId],
          assignmentIds: event.classroom.assignmentIds,
          credits: event.classroom.credits,
          tags: event.classroom.tags,
          classroomSubject: event.classroom.classroomSubject,
        );
        final response = await repository.createClassroom(classroomWithTeacher);

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Classroom created successfully
          final classroom = Classroom.fromJson(response.data);

          // Emit success for single creation
          emit(ClassroomSingleOriginalSuccess(classroom));

          // Optionally, trigger a refresh of classroom list
          add(InitializeClassroomPaging(extended: false));
          add(
            FetchNextClassroomPage(
              pageSize: 10,
              extended: false,
              teacherId: teacherId,
            ),
          );
        } else {
          emit(ClassroomFailure(Exception('Failed to create classroom')));
        }
      } catch (error) {
        emit(ClassroomFailure(error));
      }
    });

    /// Fetch paginated classrooms
    on<FetchNextClassroomPage>((event, emit) async {
      final currentState = state;

      if (event.extended) {
        PagingState<int, ClassroomExtended> pagingState =
            currentState is ClassroomExtendedSuccess
            ? currentState.pagingState
            : PagingState<int, ClassroomExtended>();

        emit(ClassroomExtendedSuccess(pagingState.copyWith(isLoading: true)));

        try {
          final int nextOffset =
              (pagingState.keys?.last ?? 0) +
              (pagingState.pages?.lastOrNull?.length ?? 0);

          final response = await repository.getClassrooms(
            limit: event.pageSize,
            offset: nextOffset,
            extended: true,
            teacherIds: [],
          );

          if (response.statusCode == 200) {
            final List<ClassroomExtended> classrooms = (response.data ?? [])
                .map<ClassroomExtended>(
                  (item) => ClassroomExtended.fromJson(item),
                )
                .toList();

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
        PagingState<int, Classroom> pagingState =
            currentState is ClassroomOriginalSuccess
            ? currentState.pagingState
            : PagingState<int, Classroom>();

        emit(ClassroomOriginalSuccess(pagingState.copyWith(isLoading: true)));

        try {
          final int nextOffset =
              (pagingState.keys?.last ?? 0) +
              (pagingState.pages?.lastOrNull?.length ?? 0);

          final response = await repository.getClassrooms(
            limit: event.pageSize,
            offset: nextOffset,
            extended: false,
            teacherIds: [],
          );

          if (response.statusCode == 200) {
            final List<Classroom> classrooms = (response.data ?? [])
                .map<Classroom>((item) => Classroom.fromJson(item))
                .toList();

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

    /// Initialize paging
    on<InitializeClassroomPaging>((event, emit) {
      if (event.extended) {
        emit(
          ClassroomExtendedSuccess(
            PagingState<int, ClassroomExtended>(isLoading: true),
          ),
        );
      } else {
        emit(
          ClassroomOriginalSuccess(
            PagingState<int, Classroom>(isLoading: true),
          ),
        );
      }
    });

    /// Fetch classroom by ID
    on<FetchClassroomById>((event, emit) async {
      emit(ClassroomSingleLoading());
      try {
        final response = await repository.getClassroom(
          id: event.id,
          extended: event.extended,
        );

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

    /// Update classroom
    on<UpdateClassroom>((event, emit) async {
      emit(ClassroomSingleLoading());
      try {
        final teacherId = event.teacherId;
        if (event.classroom.name.isEmpty || teacherId.isEmpty) {
          emit(
            ClassroomFailure(
              Exception('Name, teacherId, and credits are required'),
            ),
          );
          return;
        }
        final classroomWithTeacher = Classroom(
          id: event.classroom.id,
          name: event.classroom.name,
          teacherIds: [teacherId],
          assignmentIds: event.classroom.assignmentIds,
          credits: event.classroom.credits,
          tags: event.classroom.tags,
          classroomSubject: event.classroom.classroomSubject,
        );
        final response = await repository.updateClassroom(
          event.id,
          classroomWithTeacher,
        );
        if (response.statusCode == 200) {
          final classroom = Classroom.fromJson(response.data);
          emit(ClassroomSingleOriginalSuccess(classroom));
          add(InitializeClassroomPaging(extended: false));
          add(
            FetchNextClassroomPage(
              pageSize: 10,
              extended: false,
              teacherId: teacherId,
            ),
          );
        } else {
          emit(ClassroomFailure(Exception('Failed to update classroom')));
        }
      } catch (error) {
        emit(ClassroomFailure(error));
      }
    });

    /// Delete classroom
    on<DeleteClassroom>((event, emit) async {
      emit(ClassroomSingleLoading());
      try {
        final response = await repository.deleteClassroom(event.id);
        if (response.statusCode == 200 || response.statusCode == 204) {
          add(InitializeClassroomPaging(extended: false));
        } else {
          emit(ClassroomFailure(Exception('Failed to delete classroom')));
        }
      } catch (error) {
        emit(ClassroomFailure(error));
      }
    });
  }
}
