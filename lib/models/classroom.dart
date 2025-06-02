class Classroom {
  String id;
  String subject;
  List<String> teacherIds;
  List<String> assignmentIds;
  int credits;
  List<String> tags;

  Classroom({
    required this.id,
    required this.subject,
    required this.teacherIds,
    required this.assignmentIds,
    required this.credits,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'teacherIds': teacherIds,
      'assignmentIds': assignmentIds,
      'credits': credits,
      'tags': tags,
    };
  }

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'],
      subject: json['subject'],
      teacherIds: List<String>.from(json['teacherIds']),
      assignmentIds: List<String>.from(json['assignmentIds']),
      credits: json['credits'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}