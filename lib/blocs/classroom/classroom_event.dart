part of 'classroom_bloc.dart';

@immutable
sealed class ClassroomEvent {}

class LoadClassrooms extends ClassroomEvent {
  final String teacherId;
  final int limit;
  final int offset;
  final bool extended;

  LoadClassrooms({
    required this.teacherId,
    this.limit = 10,
    this.offset = 0,
    this.extended = false,
  });
}

class RefreshClassrooms extends ClassroomEvent {
  final String teacherId;

  RefreshClassrooms({required this.teacherId});
}
