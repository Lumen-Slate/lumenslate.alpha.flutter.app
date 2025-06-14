class AssessorAgentSerializer {
  final String id;
  final String assignmentId;
  final String studentId;
  final int totalPointsAwarded;
  final int totalMaxPoints;
  final double percentageScore;
  final List<MCQResult>? mcqResults;
  final List<MSQResult>? msqResults;
  final List<NATResult>? natResults;
  final List<SubjectiveResult>? subjectiveResults;
  final String createdAt;
  final String updatedAt;

  AssessorAgentSerializer({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.totalPointsAwarded,
    required this.totalMaxPoints,
    required this.percentageScore,
    required this.mcqResults,
    required this.msqResults,
    required this.natResults,
    required this.subjectiveResults,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssessorAgentSerializer.fromJson(Map<String, dynamic> json) {
    return AssessorAgentSerializer(
      id: json['id'],
      assignmentId: json['assignmentId'],
      studentId: json['studentId'],
      totalPointsAwarded: json['totalPointsAwarded'],
      totalMaxPoints: json['totalMaxPoints'],
      percentageScore: (json['percentageScore'] as num).toDouble(),
      mcqResults: json['mcqResults'] == null
          ? null
          : (json['mcqResults'] as List)
              .map((e) => MCQResult.fromJson(e))
              .toList(),
      msqResults: json['msqResults'] == null
          ? null
          : (json['msqResults'] as List)
              .map((e) => MSQResult.fromJson(e))
              .toList(),
      natResults: json['natResults'] == null
          ? null
          : (json['natResults'] as List)
              .map((e) => NATResult.fromJson(e))
              .toList(),
      subjectiveResults: json['subjectiveResults'] == null
          ? null
          : (json['subjectiveResults'] as List)
              .map((e) => SubjectiveResult.fromJson(e))
              .toList(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignmentId': assignmentId,
      'studentId': studentId,
      'totalPointsAwarded': totalPointsAwarded,
      'totalMaxPoints': totalMaxPoints,
      'percentageScore': percentageScore,
      'mcqResults': mcqResults?.map((e) => e.toJson()).toList(),
      'msqResults': msqResults?.map((e) => e.toJson()).toList(),
      'natResults': natResults?.map((e) => e.toJson()).toList(),
      'subjectiveResults': subjectiveResults?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}



class MCQResult {
  final String questionId;
  final int studentAnswer;
  final int correctAnswer;
  final int pointsAwarded;
  final int maxPoints;
  final bool isCorrect;

  MCQResult({
    required this.questionId,
    required this.studentAnswer,
    required this.correctAnswer,
    required this.pointsAwarded,
    required this.maxPoints,
    required this.isCorrect,
  });

  factory MCQResult.fromJson(Map<String, dynamic> json) {
    return MCQResult(
      questionId: json['questionId'],
      studentAnswer: json['studentAnswer'],
      correctAnswer: json['correctAnswer'],
      pointsAwarded: json['pointsAwarded'],
      maxPoints: json['maxPoints'],
      isCorrect: json['isCorrect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'studentAnswer': studentAnswer,
      'correctAnswer': correctAnswer,
      'pointsAwarded': pointsAwarded,
      'maxPoints': maxPoints,
      'isCorrect': isCorrect,
    };
  }
}


class MSQResult {
  final String questionId;
  final List<int> studentAnswers;
  final List<int> correctAnswers;
  final int pointsAwarded;
  final int maxPoints;
  final bool isCorrect;

  MSQResult({
    required this.questionId,
    required this.studentAnswers,
    required this.correctAnswers,
    required this.pointsAwarded,
    required this.maxPoints,
    required this.isCorrect,
  });

  factory MSQResult.fromJson(Map<String, dynamic> json) {
    return MSQResult(
      questionId: json['questionId'],
      studentAnswers: List<int>.from(json['studentAnswers']),
      correctAnswers: List<int>.from(json['correctAnswers']),
      pointsAwarded: json['pointsAwarded'],
      maxPoints: json['maxPoints'],
      isCorrect: json['isCorrect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'studentAnswers': studentAnswers,
      'correctAnswers': correctAnswers,
      'pointsAwarded': pointsAwarded,
      'maxPoints': maxPoints,
      'isCorrect': isCorrect,
    };
  }
}

class NATResult {
  final String questionId;
  final int studentAnswer;
  final int correctAnswer;
  final int pointsAwarded;
  final int maxPoints;
  final bool isCorrect;

  NATResult({
    required this.questionId,
    required this.studentAnswer,
    required this.correctAnswer,
    required this.pointsAwarded,
    required this.maxPoints,
    required this.isCorrect,
  });

  factory NATResult.fromJson(Map<String, dynamic> json) {
    return NATResult(
      questionId: json['questionId'],
      studentAnswer: json['studentAnswer'],
      correctAnswer: json['correctAnswer'],
      pointsAwarded: json['pointsAwarded'],
      maxPoints: json['maxPoints'],
      isCorrect: json['isCorrect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'studentAnswer': studentAnswer,
      'correctAnswer': correctAnswer,
      'pointsAwarded': pointsAwarded,
      'maxPoints': maxPoints,
      'isCorrect': isCorrect,
    };
  }
}

class SubjectiveResult {
  final String questionId;
  final String studentAnswer;
  final String idealAnswer;
  final List<String> gradingCriteria;
  final int pointsAwarded;
  final int maxPoints;
  final String assessmentFeedback;
  final List<String> criteriaMet;
  final List<String> criteriaMissed;

  SubjectiveResult({
    required this.questionId,
    required this.studentAnswer,
    required this.idealAnswer,
    required this.gradingCriteria,
    required this.pointsAwarded,
    required this.maxPoints,
    required this.assessmentFeedback,
    required this.criteriaMet,
    required this.criteriaMissed,
  });

  factory SubjectiveResult.fromJson(Map<String, dynamic> json) {
    return SubjectiveResult(
      questionId: json['questionId'],
      studentAnswer: json['studentAnswer'],
      idealAnswer: json['idealAnswer'],
      gradingCriteria: List<String>.from(json['gradingCriteria']),
      pointsAwarded: json['pointsAwarded'],
      maxPoints: json['maxPoints'],
      assessmentFeedback: json['assessmentFeedback'],
      criteriaMet: List<String>.from(json['criteriaMet']),
      criteriaMissed: List<String>.from(json['criteriaMissed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'studentAnswer': studentAnswer,
      'idealAnswer': idealAnswer,
      'gradingCriteria': gradingCriteria,
      'pointsAwarded': pointsAwarded,
      'maxPoints': maxPoints,
      'assessmentFeedback': assessmentFeedback,
      'criteriaMet': criteriaMet,
      'criteriaMissed': criteriaMissed,
    };
  }
}