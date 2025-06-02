class QuestionBank {
  String id;
  String name;
  String topic;
  String teacherId;
  List<String> tags;

  QuestionBank({
    required this.id,
    required this.name,
    required this.topic,
    required this.teacherId,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'topic': topic,
      'teacherId': teacherId,
      'tags': tags,
    };
  }

  factory QuestionBank.fromJson(Map<String, dynamic> json) {
    return QuestionBank(
      id: json['id'],
      name: json['name'],
      topic: json['topic'],
      teacherId: json['teacherId'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}