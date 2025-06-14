part of 'student_bloc.dart';

@immutable
sealed class StudentState {}

class StudentInitial extends StudentState {}

class StudentOriginalSuccess extends StudentState {
  final PagingState<int, Student> pagingState;

  StudentOriginalSuccess(this.pagingState);
}


class StudentFailure extends StudentState {
  final Object error;
  StudentFailure(this.error);
}

// class StudentExtendedSuccess extends StudentState {
//   final PagingState<int, StudentExtended> pagingState;
//
//   StudentExtendedSuccess(this.pagingState);
// }
//
// class StudentFailure extends StudentState {
//   final Object error;
//   StudentFailure(this.error);
// }

class StudentSingleLoading extends StudentState {}

class StudentSingleOriginalSuccess extends StudentState {
  final Student student;
  StudentSingleOriginalSuccess(this.student);
}

class StudentSingleFailure extends StudentState {
  final Object error;
  StudentSingleFailure(this.error);
}


// class StudentSingleExtendedSuccess extends StudentState {
//   final StudentExtended student;
//   StudentSingleExtendedSuccess(this.student);
// }
//
// class StudentSingleFailure extends StudentState {
//   final Object error;
//   StudentSingleFailure(this.error);
// }

