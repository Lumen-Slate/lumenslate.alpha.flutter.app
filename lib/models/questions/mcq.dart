class MCQ {
  String id;
  String bankId;
  String question;
  List<String> variableIds;
  int points;
  List<String> options;
  int answerIndex;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isActive;

  MCQ({
    required this.id,
    required this.bankId,
    required this.question,
    required this.variableIds,
    required this.points,
    required this.options,
    required this.answerIndex,
    this.createdAt,
    this.updatedAt,
    this.isActive,
  });

  Map<String, dynamic> toJson({bool forCreation = false}) {
    Map<String, dynamic> json = {
      'bankId': bankId,
      'question': question,
      'variableIds': variableIds,
      'points': points,
      'options': options,
      'answerIndex': answerIndex,
    };
    
    // Only include id if not for creation (backend generates its own IDs)
    if (!forCreation) {
      json['id'] = id;
    }
    
    return json;
  }

  factory MCQ.fromJson(Map<String, dynamic> json) {
    return MCQ(
      id: json['id'] ?? '',
      bankId: json['bankId'] ?? '',
      question: json['question'] ?? '',
      variableIds: List<String>.from(json['variableIds'] ?? []),
      points: json['points'] ?? 0,
      options: List<String>.from(json['options'] ?? []),
      answerIndex: json['answerIndex'] ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      isActive: json['isActive'],
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
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return MCQ(
      id: id ?? this.id,
      bankId: bankId ?? this.bankId,
      question: question ?? this.question,
      variableIds: variableIds ?? this.variableIds,
      points: points ?? this.points,
      options: options ?? this.options,
      answerIndex: answerIndex ?? this.answerIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}