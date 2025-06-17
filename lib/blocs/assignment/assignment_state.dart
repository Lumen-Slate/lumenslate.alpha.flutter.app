part of 'assignment_bloc.dart';

@immutable
abstract class AssignmentState {}

class AssignmentInitial extends AssignmentState {}

class AssignmentOriginalSuccess extends AssignmentState {
  final PagingState<int, Assignment> pagingState;

  AssignmentOriginalSuccess(this.pagingState);
}

class AssignmentExtendedSuccess extends AssignmentState {
  final PagingState<int, AssignmentExtended> pagingState;

  AssignmentExtendedSuccess(this.pagingState);
}

class AssignmentFailure extends AssignmentState {
  final Object error;
  AssignmentFailure(this.error);
}

// New states for fetching a single assignment
class AssignmentSingleLoading extends AssignmentState {}

class AssignmentSingleOriginalSuccess extends AssignmentState {
  final Assignment assignment;
  AssignmentSingleOriginalSuccess(this.assignment);
}

class AssignmentSingleExtendedSuccess extends AssignmentState {
  final AssignmentExtended assignment;
  AssignmentSingleExtendedSuccess(this.assignment);
}

class AssignmentSingleFailure extends AssignmentState {
  final Object error;
  AssignmentSingleFailure(this.error);
}
