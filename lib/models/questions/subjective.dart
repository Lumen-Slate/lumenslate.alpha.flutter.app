class Subjective {
  String id;
  String bankId;
  String question;
  List<String> variableIds;
  int points;
  String? idealAnswer;
  List<String>? gradingCriteria;
  String subject;
  String difficulty;

  Subjective({
    required this.id,
    required this.bankId,
    required this.question,
    required this.variableIds,
    required this.points,
    this.idealAnswer,
    this.gradingCriteria,
    required this.subject,
    required this.difficulty,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bankId': bankId,
      'question': question,
      'variableIds': variableIds,
      'points': points,
      'idealAnswer': idealAnswer,
      'gradingCriteria': gradingCriteria,
      'subject': subject,
      'difficulty': difficulty,
    };
  }

  factory Subjective.fromJson(Map<String, dynamic> json) {
    return Subjective(
      id: json['id'],
      bankId: json['bankId'],
      question: json['question'],
      variableIds: List<String>.from(json['variableIds'] ?? []),
      points: json['points'],
      idealAnswer: json['idealAnswer'],
      gradingCriteria: List<String>.from(json['gradingCriteria'] ?? []),
      subject: json['subject'] ?? '',
      difficulty: json['difficulty'] ?? '',
    );
  }

  Subjective copyWith({
    String? id,
    String? bankId,
    String? question,
    List<String>? variableIds,
    int? points,
    String? idealAnswer,
    List<String>? gradingCriteria,
    String? subject,
    String? difficulty,
  }) {
    return Subjective(
      id: id ?? this.id,
      bankId: bankId ?? this.bankId,
      question: question ?? this.question,
      variableIds: variableIds ?? this.variableIds,
      points: points ?? this.points,
      idealAnswer: idealAnswer ?? this.idealAnswer,
      gradingCriteria: gradingCriteria ?? this.gradingCriteria,
      subject: subject ?? this.subject,
      difficulty: difficulty ?? this.difficulty,
    );
  }

}