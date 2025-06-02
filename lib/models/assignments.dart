class Assignments {
  String id;
  String title;
  String body;
  DateTime dueDate;
  DateTime createdAt;
  int points;
  List<String> commentIds;
  List<String>? mcqIds;
  List<String>? msqIds;
  List<String>? natIds;
  List<String>? subjectiveIds;

  Assignments({
    required this.id,
    required this.title,
    required this.body,
    required this.dueDate,
    required this.createdAt,
    required this.points,
    required this.commentIds,
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

  factory Assignments.fromJson(Map<String, dynamic> json) {
    return Assignments(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      dueDate: json['dueDate'],
      createdAt: json['createdAt'],
      points: json['points'],
      commentIds: json['commentIds'],
      mcqIds: json['mcqIds'],
      msqIds: json['msqIds'],
      natIds: json['natIds'],
      subjectiveIds: json['subjectiveIds'],
    );
  }
}