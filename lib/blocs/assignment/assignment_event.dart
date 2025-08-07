part of 'assignment_bloc.dart';

@immutable
sealed class AssignmentEvent {}

final class FetchNextAssignmentPage extends AssignmentEvent {
  final String teacherId;
  final int pageSize;
  final bool extended;
  final String? searchQuery;

  FetchNextAssignmentPage({
    required this.teacherId,
    this.pageSize = 3,
    this.extended = false,
    this.searchQuery,
  });
}

class InitializeAssignmentPaging extends AssignmentEvent {
  final String teacherId;
  final bool extended;

  InitializeAssignmentPaging({
    required this.teacherId,
    this.extended = false,
  });
}

class SearchAssignments extends AssignmentEvent {
  final String teacherId;
  final String searchQuery;
  final bool extended;

  SearchAssignments({
    required this.teacherId,
    required this.searchQuery,
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
