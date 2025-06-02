class Comments {
  String id;
  String commentBody;

  Comments({
    required this.id,
    required this.commentBody,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commentBody': commentBody,
    };
  }

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      id: json['id'],
      commentBody: json['commentBody'],
    );
  }
}