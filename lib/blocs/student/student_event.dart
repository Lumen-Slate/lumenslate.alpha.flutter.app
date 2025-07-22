part of 'student_bloc.dart';

@immutable
sealed class StudentEvent {}

final class FetchNextStudentPage extends StudentEvent {
  final int pageSize;
  final bool extended;
  final String? classIds;
  final String? email;
  final String? rollNo;
  final String? searchQuery;

  FetchNextStudentPage({
    this.pageSize = 3,
    this.extended = false,
    this.classIds,
    this.email,
    this.rollNo,
    this.searchQuery,
  });
}

class InitializeStudentPaging extends StudentEvent {
  final bool extended;
  final String? classIds;
  final String? email;
  final String? rollNo;
  final String? searchQuery;

  InitializeStudentPaging({
    this.extended = false,
    this.classIds,
    this.email,
    this.rollNo,
    this.searchQuery,
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

class SearchStudents extends StudentEvent {
  final String? email;
  final String? rollNo;
  final String? searchQuery;
  final String? classIds;
  final bool extended;

  SearchStudents({
    this.email,
    this.rollNo,
    this.searchQuery,
    this.classIds,
    this.extended = false,
  });
}
