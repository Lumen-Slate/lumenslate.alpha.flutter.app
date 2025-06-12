class MSQ {
  String id;
  String bankId;
  String question;
  List<String> variableIds;
  int points;
  List<String> options;
  List<int> answerIndices;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isActive;

  MSQ({
    required this.id,
    required this.bankId,
    required this.question,
    required this.variableIds,
    required this.points,
    required this.options,
    required this.answerIndices,
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
      'answerIndices': answerIndices,
    };
    
    // Only include id if not for creation (backend generates its own IDs)
    if (!forCreation) {
      json['id'] = id;
    }
    
    return json;
  }

  factory MSQ.fromJson(Map<String, dynamic> json) {
    return MSQ(
      id: json['id'] ?? '',
      bankId: json['bankId'] ?? '',
      question: json['question'] ?? '',
      variableIds: List<String>.from(json['variableIds'] ?? []),
      points: json['points'] ?? 0,
      options: List<String>.from(json['options'] ?? []),
      answerIndices: List<int>.from(json['answerIndices'] ?? []),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      isActive: json['isActive'],
    );
  }

  MSQ copyWith({
    String? id,
    String? bankId,
    String? question,
    List<String>? variableIds,
    int? points,
    List<String>? options,
    List<int>? answerIndices,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return MSQ(
      id: id ?? this.id,
      bankId: bankId ?? this.bankId,
      question: question ?? this.question,
      variableIds: variableIds ?? this.variableIds,
      points: points ?? this.points,
      options: options ?? this.options,
      answerIndices: answerIndices ?? this.answerIndices,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}