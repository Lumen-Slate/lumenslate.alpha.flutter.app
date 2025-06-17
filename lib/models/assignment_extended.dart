import 'comments.dart';
import 'questions/mcq.dart';
import 'questions/msq.dart';
import 'questions/nat.dart';
import 'questions/subjective.dart';

class AssignmentExtended {
  String id;
  String title;
  String body;
  DateTime dueDate;
  DateTime createdAt;
  int points;
  List<Comments>? comments;
  List<MCQ>? mcqs;
  List<MSQ>? msqs;
  List<NAT>? nats;
  List<Subjective>? subjectives;

  AssignmentExtended({
    required this.id,
    required this.title,
    required this.body,
    required this.dueDate,
    required this.createdAt,
    required this.points,
    this.comments,
    this.mcqs,
    this.msqs,
    this.nats,
    this.subjectives,
  });

  factory AssignmentExtended.fromJson(Map<String, dynamic> json) {
    return AssignmentExtended(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      dueDate: DateTime.parse(json['dueDate']),
      createdAt: DateTime.parse(json['createdAt']),
      points: json['points'],
      comments: (json['comments'] as List?)?.map((e) => Comments.fromJson(e)).toList(),
      mcqs: (json['mcqs'] as List?)?.map((e) => MCQ.fromJson(e)).toList(),
      msqs: (json['msqs'] as List?)?.map((e) => MSQ.fromJson(e)).toList(),
      nats: (json['nats'] as List?)?.map((e) => NAT.fromJson(e)).toList(),
      subjectives: (json['subjectives'] as List?)?.map((e) => Subjective.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'points': points,
      'comments': comments?.map((e) => e.toJson()).toList(),
      'mcqs': mcqs?.map((e) => e.toJson()).toList(),
      'msqs': msqs?.map((e) => e.toJson()).toList(),
      'nats': nats?.map((e) => e.toJson()).toList(),
      'subjectives': subjectives?.map((e) => e.toJson()).toList(),
    };
  }
}