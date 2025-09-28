part of 'student_classroom_bloc.dart';

@immutable
sealed class StudentClassroomEvent {}

final class InitializeStudentClassroomPaging extends StudentClassroomEvent {
  final String studentId;
  final int pageSize;

  InitializeStudentClassroomPaging({
    required this.studentId,
    this.pageSize = 10,
  });
}

final class FetchNextStudentClassroomPage extends StudentClassroomEvent {
  final String studentId;
  final int pageSize;

  FetchNextStudentClassroomPage({
    required this.studentId,
    this.pageSize = 10,
  });
}

final class SearchStudentClassrooms extends StudentClassroomEvent {
  final String studentId;
  final int pageSize;

  SearchStudentClassrooms({
    required this.studentId,
    this.pageSize = 10,
  });
}

final class JoinStudentClassroom extends StudentClassroomEvent {
  final String studentId;
  final String classroomCode;

  JoinStudentClassroom({
    required this.studentId,
    required this.classroomCode,
  });
}
