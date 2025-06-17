part of 'classroom_bloc.dart';

@immutable
sealed class ClassroomState {}

final class ClassroomInitial extends ClassroomState {}

class ClassroomLoading extends ClassroomState {}

class ClassroomLoadSuccess extends ClassroomState {
  final List<Classroom> classrooms;

  ClassroomLoadSuccess({
    required this.classrooms,
  });
}

class ClassroomLoadFailure extends ClassroomState {
  final String error;

  ClassroomLoadFailure(this.error);
}
