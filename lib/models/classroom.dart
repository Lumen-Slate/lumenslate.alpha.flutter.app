class Classroom {
  String id;
  String name;
  List<String> teacherIds;
  List<String> assignmentIds;
  int credits;
  List<String>? tags;
  String? classroomCode;
  String? classroomSubject;

  Classroom({
    required this.id,
    required this.name,
    required this.teacherIds,
    required this.assignmentIds,
    required this.credits,
    this.tags,
    this.classroomCode,
    this.classroomSubject,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'teacherIds': teacherIds,
      'assignmentIds': assignmentIds,
      'credits': credits,
      'tags': tags,
      'classroomCode': classroomCode,
      'classroomSubject': classroomSubject,
    };
  }

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'],
      name: json['name'],
      teacherIds: List<String>.from(json['teacherIds']),
      assignmentIds: List<String>.from(json['assignmentIds']),
      credits: json['credits'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      classroomCode: json['classroomCode'],
      classroomSubject: json['classroomSubject'],
    );
  }
}
