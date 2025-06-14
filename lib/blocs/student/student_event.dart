part of 'student_bloc.dart';

@immutable
sealed class StudentEvent {}

final class FetchNextStudentPage extends StudentEvent {
  final int pageSize;
  final bool extended;

  FetchNextStudentPage({
    this.pageSize = 3,
    this.extended = false,
  });
}

class InitializeStudentPaging extends StudentEvent {
  final bool extended;

  InitializeStudentPaging({
    this.extended = false,
  });
}

class FetchStudentById extends StudentEvent {
  final String id;
  final bool extended;

  FetchStudentById({
    required this.id,
    this.extended = false,
  });
}
