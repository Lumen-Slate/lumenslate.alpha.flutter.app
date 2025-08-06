class ReportCardAgentSerializer {
  final ReportCard reportCard;
  final String databaseId;
  final String savedAt;

  ReportCardAgentSerializer({
    required this.reportCard,
    required this.databaseId,
    required this.savedAt,
  });

  factory ReportCardAgentSerializer.fromJson(Map<String, dynamic> json) {
    return ReportCardAgentSerializer(
      reportCard: ReportCard.fromJson(json['reportCard'] ?? json['report_card']),
      databaseId: json['databaseId'] ?? json['database_id'],
      savedAt: json['savedAt'] ?? json['saved_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportCard': reportCard.toJson(),
      'databaseId': databaseId,
      'savedAt': savedAt,
    };
  }
}

class ReportCard {
  final String studentId;
  final String studentName;
  final String reportPeriod;
  final String generationDate;
  final OverallPerformance overallPerformance;
  final List<SubjectPerformance> subjectPerformance;
  final List<AssignmentSummary> assignmentSummaries;
  final String aiRemarks;
  final String teacherRemarks;
  final StudentInsights studentInsights;

  ReportCard({
    required this.studentId,
    required this.studentName,
    required this.reportPeriod,
    required this.generationDate,
    required this.overallPerformance,
    required this.subjectPerformance,
    required this.assignmentSummaries,
    required this.aiRemarks,
    required this.teacherRemarks,
    required this.studentInsights,
  });

  factory ReportCard.fromJson(Map<String, dynamic> json) {
    return ReportCard(
      studentId: json['studentId'] ?? json['student_id'],
      studentName: json['studentName'] ?? json['student_name'],
      reportPeriod: json['reportPeriod'] ?? json['report_period'],
      generationDate: json['generationDate'] ?? json['generation_date'],
      overallPerformance: OverallPerformance.fromJson(json['overallPerformance'] ?? json['overall_performance']),
      subjectPerformance: (json['subjectPerformance'] ?? json['subject_performance'] ?? [])
          .map<SubjectPerformance>((e) => SubjectPerformance.fromJson(e))
          .toList(),
      assignmentSummaries: (json['assignmentSummaries'] ?? json['assignment_summaries'] ?? [])
          .map<AssignmentSummary>((e) => AssignmentSummary.fromJson(e))
          .toList(),
      aiRemarks: json['aiRemarks'] ?? json['ai_remarks'],
      teacherRemarks: json['teacherRemarks'] ?? json['teacher_remarks'],
      studentInsights: StudentInsights.fromJson(json['studentInsights'] ?? json['student_insights']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'reportPeriod': reportPeriod,
      'generationDate': generationDate,
      'overallPerformance': overallPerformance.toJson(),
      'subjectPerformance': subjectPerformance.map((e) => e.toJson()).toList(),
      'assignmentSummaries': assignmentSummaries.map((e) => e.toJson()).toList(),
      'aiRemarks': aiRemarks,
      'teacherRemarks': teacherRemarks,
      'studentInsights': studentInsights.toJson(),
    };
  }
}

class OverallPerformance {
  final int totalAssignmentsCompleted;
  final double overallPercentage;
  final String improvementTrend;
  final String strongestQuestionType;
  final String weakestQuestionType;

  OverallPerformance({
    required this.totalAssignmentsCompleted,
    required this.overallPercentage,
    required this.improvementTrend,
    required this.strongestQuestionType,
    required this.weakestQuestionType,
  });

  factory OverallPerformance.fromJson(Map<String, dynamic> json) {
    return OverallPerformance(
      totalAssignmentsCompleted: json['totalAssignmentsCompleted'] ?? json['total_assignments_completed'],
      overallPercentage: (json['overallPercentage'] ?? json['overall_percentage'] ?? 0).toDouble(),
      improvementTrend: json['improvementTrend'] ?? json['improvement_trend'],
      strongestQuestionType: json['strongestQuestionType'] ?? json['strongest_question_type'],
      weakestQuestionType: json['weakestQuestionType'] ?? json['weakest_question_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAssignmentsCompleted': totalAssignmentsCompleted,
      'overallPercentage': overallPercentage,
      'improvementTrend': improvementTrend,
      'strongestQuestionType': strongestQuestionType,
      'weakestQuestionType': weakestQuestionType,
    };
  }
}

class SubjectPerformance {
  final String subjectName;
  final double percentageScore;
  final int assignmentCount;
  final double mcqAccuracy;
  final double msqAccuracy;
  final double natAccuracy;
  final double subjectiveAvgScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final String improvementTrend;

  SubjectPerformance({
    required this.subjectName,
    required this.percentageScore,
    required this.assignmentCount,
    required this.mcqAccuracy,
    required this.msqAccuracy,
    required this.natAccuracy,
    required this.subjectiveAvgScore,
    required this.strengths,
    required this.weaknesses,
    required this.improvementTrend,
  });

  factory SubjectPerformance.fromJson(Map<String, dynamic> json) {
    return SubjectPerformance(
      subjectName: json['subjectName'] ?? json['subject_name'],
      percentageScore: (json['percentageScore'] ?? json['percentage_score'] ?? 0).toDouble(),
      assignmentCount: json['assignmentCount'] ?? json['assignment_count'] ?? 0,
      mcqAccuracy: (json['mcqAccuracy'] ?? json['mcq_accuracy'] ?? 0).toDouble(),
      msqAccuracy: (json['msqAccuracy'] ?? json['msq_accuracy'] ?? 0).toDouble(),
      natAccuracy: (json['natAccuracy'] ?? json['nat_accuracy'] ?? 0).toDouble(),
      subjectiveAvgScore: (json['subjectiveAvgScore'] ?? json['subjective_avg_score'] ?? 0).toDouble(),
      strengths: List<String>.from(json['strengths'] ?? []),
      weaknesses: List<String>.from(json['weaknesses'] ?? []),
      improvementTrend: json['improvementTrend'] ?? json['improvement_trend'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectName': subjectName,
      'percentageScore': percentageScore,
      'assignmentCount': assignmentCount,
      'mcqAccuracy': mcqAccuracy,
      'msqAccuracy': msqAccuracy,
      'natAccuracy': natAccuracy,
      'subjectiveAvgScore': subjectiveAvgScore,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'improvementTrend': improvementTrend,
    };
  }
}

class AssignmentSummary {
  final String assignmentId;
  final String assignmentTitle;
  final double percentageScore;
  final String subject;

  AssignmentSummary({
    required this.assignmentId,
    required this.assignmentTitle,
    required this.percentageScore,
    required this.subject,
  });

  factory AssignmentSummary.fromJson(Map<String, dynamic> json) {
    return AssignmentSummary(
      assignmentId: json['assignmentId'] ?? json['assignment_id'] ?? '',
      assignmentTitle: json['assignmentTitle'] ?? json['assignment_title'] ?? '',
      percentageScore: (json['percentageScore'] ?? json['percentage_score'] ?? 0).toDouble(),
      subject: json['subject'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignmentId': assignmentId,
      'assignmentTitle': assignmentTitle,
      'percentageScore': percentageScore,
      'subject': subject,
    };
  }
}

class StudentInsights {
  final List<String> keyStrengths;
  final List<String> areasForImprovement;
  final List<String> recommendedActions;

  StudentInsights({
    required this.keyStrengths,
    required this.areasForImprovement,
    required this.recommendedActions,
  });

  factory StudentInsights.fromJson(Map<String, dynamic> json) {
    return StudentInsights(
      keyStrengths: List<String>.from(json['keyStrengths'] ?? json['key_strengths'] ?? []),
      areasForImprovement: List<String>.from(json['areasForImprovement'] ?? json['areas_for_improvement'] ?? []),
      recommendedActions: List<String>.from(json['recommendedActions'] ?? json['recommended_actions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'keyStrengths': keyStrengths,
      'areasForImprovement': areasForImprovement,
      'recommendedActions': recommendedActions,
    };
  }
}