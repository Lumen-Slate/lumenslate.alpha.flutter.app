class MCQ {
  String id;
  String bankId;
  String question;
  List<String> variableIds;
  int points;
  List<String> options;
  int answerIndex;

  MCQ({
    required this.id,
    required this.bankId,
    required this.question,
    required this.variableIds,
    required this.points,
    required this.options,
    required this.answerIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bankId': bankId,
      'question': question,
      'variableIds': variableIds,
      'points': points,
      'options': options,
      'answerIndex': answerIndex,
    };
  }

  factory MCQ.fromJson(Map<String, dynamic> json) {
    return MCQ(
      id: json['id'],
      bankId: json['bankId'],
      question: json['question'],
      variableIds: List<String>.from(json['variableIds']),
      points: json['points'],
      options: List<String>.from(json['options']),
      answerIndex: json['answerIndex'],
    );
  }

  MCQ copyWith({
    String? id,
    String? bankId,
    String? question,
    List<String>? variableIds,
    int? points,
    List<String>? options,
    int? answerIndex,
  }) {
    return MCQ(
      id: id ?? this.id,
      bankId: bankId ?? this.bankId,
      question: question ?? this.question,
      variableIds: variableIds ?? this.variableIds,
      points: points ?? this.points,
      options: options ?? this.options,
      answerIndex: answerIndex ?? this.answerIndex,
    );
  }
}