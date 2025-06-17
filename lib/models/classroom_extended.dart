import 'teacher.dart';
import 'assignments.dart';

class ClassroomExtended {
  String id;
  String subject;
  List<Teacher> teachers;
  List<Assignment> assignments;
  int credits;
  List<String> tags;

  ClassroomExtended({
    required this.id,
    required this.subject,
    required this.teachers,
    required this.assignments,
    required this.credits,
    required this.tags,
  });

  factory ClassroomExtended.fromJson(Map<String, dynamic> json) {
    return ClassroomExtended(
      id: json['id'],
      subject: json['subject'],
      teachers: (json['teachers'] as List)
          .map((e) => Teacher.fromJson(e))
          .toList(),
      assignments: (json['assignments'] as List)
          .map((e) => Assignment.fromJson(e))
          .toList(),
      credits: json['credits'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'teachers': teachers.map((e) => e.toJson()).toList(),
      'assignments': assignments.map((e) => e.toJson()).toList(),
      'credits': credits,
      'tags': tags,
    };
  }
}