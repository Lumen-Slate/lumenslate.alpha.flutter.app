part of 'assignment_bloc.dart';

@immutable
sealed class AssignmentEvent {}

final class FetchNextAssignmentPage extends AssignmentEvent {
  final String teacherId;
  final int pageSize;

  FetchNextAssignmentPage({
    required this.teacherId,
    this.pageSize = 3,
  });
}
