class AssignmentGeneratorGeneralSerializer {
  final String assignmentId;
  final String title;
  final String body;
  final int mcqCount;
  final int natCount;
  final int msqCount;
  final int subjectiveCount;

  AssignmentGeneratorGeneralSerializer({
    required this.assignmentId,
    required this.title,
    required this.body,
    required this.mcqCount,
    required this.natCount,
    required this.msqCount,
    required this.subjectiveCount,
  });

  factory AssignmentGeneratorGeneralSerializer.fromJson(Map<String, dynamic> json) {
    return AssignmentGeneratorGeneralSerializer(
      assignmentId: json['assignmentId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      mcqCount: json['mcqCount'] as int,
      natCount: json['natCount'] as int,
      msqCount: json['msqCount'] as int,
      subjectiveCount: json['subjectiveCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignmentId': assignmentId,
      'title': title,
      'body': body,
      'mcqCount': mcqCount,
      'natCount': natCount,
      'msqCount': msqCount,
      'subjectiveCount': subjectiveCount,
    };
  }
}
