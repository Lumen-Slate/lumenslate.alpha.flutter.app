part of 'classroom_bloc.dart';

@immutable
abstract class ClassroomState {}

class ClassroomInitial extends ClassroomState {}

class ClassroomOriginalSuccess extends ClassroomState {
  final PagingState<int, Classroom> pagingState;

  ClassroomOriginalSuccess(this.pagingState);
}

class ClassroomExtendedSuccess extends ClassroomState {
  final PagingState<int, ClassroomExtended> pagingState;

  ClassroomExtendedSuccess(this.pagingState);
}

class ClassroomFailure extends ClassroomState {
  final Object error;
  ClassroomFailure(this.error);
}

// States for fetching a single classroom
class ClassroomSingleLoading extends ClassroomState {}

class ClassroomSingleOriginalSuccess extends ClassroomState {
  final Classroom classroom;
  ClassroomSingleOriginalSuccess(this.classroom);
}

class ClassroomSingleExtendedSuccess extends ClassroomState {
  final ClassroomExtended classroom;
  ClassroomSingleExtendedSuccess(this.classroom);
}

class ClassroomSingleFailure extends ClassroomState {
  final Object error;
  ClassroomSingleFailure(this.error);
}
