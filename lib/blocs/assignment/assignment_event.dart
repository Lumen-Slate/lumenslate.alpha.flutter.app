part of 'assignment_bloc.dart';

@immutable
sealed class AssignmentEvent {}

final class FetchNextAssignmentPage extends AssignmentEvent {
  final String teacherId;
  final int pageSize;
  final bool extended;

  FetchNextAssignmentPage({
    required this.teacherId,
    this.pageSize = 3,
    this.extended = false,
  });
}

class InitializeAssignmentPaging extends AssignmentEvent {
  final bool extended;

  InitializeAssignmentPaging({
    this.extended = false,
  });
}

// New event for fetching a single assignment by id
class FetchAssignmentById extends AssignmentEvent {
  final String id;
  final bool extended;

  FetchAssignmentById({
    required this.id,
    this.extended = false,
  });
}
