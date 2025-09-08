part of 'classroom_bloc.dart';

@immutable
sealed class ClassroomEvent {}

/// Fetch classrooms with pagination
final class FetchNextClassroomPage extends ClassroomEvent {
  final String teacherId;
  final int pageSize;
  final bool extended;

  FetchNextClassroomPage({
    required this.teacherId,
    this.pageSize = 10,
    this.extended = false,
  });
}

/// Initialize paging
final class InitializeClassroomPaging extends ClassroomEvent {
  final bool extended;

  InitializeClassroomPaging({this.extended = false});
}

/// Fetch a single classroom by ID
final class FetchClassroomById extends ClassroomEvent {
  final String id;
  final bool extended;

  FetchClassroomById({required this.id, this.extended = false});
}

/// Create a new classroom
final class CreateClassroom extends ClassroomEvent {
  final Classroom classroom;
  final String teacherId;
  CreateClassroom({required this.classroom, required this.teacherId});
}

/// Update a classroom
final class UpdateClassroom extends ClassroomEvent {
  final String id;
  final Classroom classroom;
  final String teacherId;
  UpdateClassroom({
    required this.id,
    required this.classroom,
    required this.teacherId,
  });
}

/// Delete a classroom
final class DeleteClassroom extends ClassroomEvent {
  final String id;
  DeleteClassroom(this.id);
}
