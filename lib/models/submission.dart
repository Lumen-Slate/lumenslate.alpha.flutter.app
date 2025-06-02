class Submission {
  String id;
  String studentId;
  String assignmentId;
  Map<String, String>? mcqAnswers; // Map<QuestionID, MCQAnswer>
  Map<String, List<String>>? msqAnswers; // Map<QuestionID, MSQAnswer>
  Map<String, int>? natAnswers; // Map<QuestionID, NATAnswer>
  Map<String, String> subjectiveAnswers; // Map<QuestionID, SubjectiveAnswer>

  Submission({
    required this.id,
    required this.studentId,
    required this.assignmentId,
    this.mcqAnswers,
    this.msqAnswers,
    this.natAnswers,
    required this.subjectiveAnswers,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'assignmentId': assignmentId,
      'mcqAnswers': mcqAnswers,
      'msqAnswers': msqAnswers,
      'natAnswers': natAnswers,
      'subjectiveAnswers': subjectiveAnswers,
    };
  }

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'],
      studentId: json['studentId'],
      assignmentId: json['assignmentId'],
      mcqAnswers: json['mcqAnswers'],
      msqAnswers: json['msqAnswers'],
      natAnswers: json['natAnswers'],
      subjectiveAnswers: json['subjectiveAnswers'],
    );
  }
}