part of 'classroom_bloc.dart';

@immutable
sealed class ClassroomEvent {}

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

class InitializeClassroomPaging extends ClassroomEvent {
  final bool extended;

  InitializeClassroomPaging({
    this.extended = false,
  });
}

class FetchClassroomById extends ClassroomEvent {
  final String id;
  final bool extended;

  FetchClassroomById({
    required this.id,
    this.extended = false,
  });
}
