class Posts {
  String id;
  String title;
  String body;
  List<String> attachments;
  String userId;
  List<String> commentIds;

  Posts({
    required this.id,
    required this.title,
    required this.body,
    required this.attachments,
    required this.userId,
    required this.commentIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'attachments': attachments,
      'userId': userId,
      'commentIds': commentIds,
    };
  }

  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      attachments: json['attachments'],
      userId: json['userId'],
      commentIds: json['commentIds'],
    );
  }
}