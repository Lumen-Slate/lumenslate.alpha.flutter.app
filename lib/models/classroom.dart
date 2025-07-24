class Classroom {
  String id;
  String name;
  List<String> teacherIds;
  List<String> assignmentIds;
  int credits;
  List<String> tags;

  Classroom({
    required this.id,
    required this.name,
    required this.teacherIds,
    required this.assignmentIds,
    required this.credits,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'teacherIds': teacherIds,
      'assignmentIds': assignmentIds,
      'credits': credits,
      'tags': tags,
    };
  }

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'],
      name: json['name'],
      teacherIds: List<String>.from(json['teacherIds']),
      assignmentIds: List<String>.from(json['assignmentIds']),
      credits: json['credits'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
