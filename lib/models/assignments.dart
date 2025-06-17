class Assignment {
  String id;
  String title;
  String body;
  DateTime dueDate;
  DateTime createdAt;
  int points;
  List<String>? commentIds;
  List<String>? mcqIds;
  List<String>? msqIds;
  List<String>? natIds;
  List<String>? subjectiveIds;

  Assignment({
    required this.id,
    required this.title,
    required this.body,
    required this.dueDate,
    required this.createdAt,
    required this.points,
    this.commentIds,
    this.mcqIds,
    this.msqIds,
    this.natIds,
    this.subjectiveIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'dueDate': dueDate,
      'createdAt': createdAt,
      'points': points,
      'commentIds': commentIds,
      'mcqIds': mcqIds,
      'msqIds': msqIds,
      'natIds': natIds,
      'subjectiveIds': subjectiveIds,
    };
  }

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      dueDate: DateTime.parse(json['dueDate']),
      createdAt: DateTime.parse(json['createdAt']),
      points: json['points'],
      commentIds: (json['commentIds'] as List?)?.map((e) => e.toString()).toList(),
      mcqIds: (json['mcqIds'] as List?)?.map((e) => e.toString()).toList(),
      msqIds: (json['msqIds'] as List?)?.map((e) => e.toString()).toList(),
      natIds: (json['natIds'] as List?)?.map((e) => e.toString()).toList(),
      subjectiveIds: (json['subjectiveIds'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}