class ChatMessage {
  String id;
  String message;
  Map<String, dynamic>? data;
  String agentName;
  DateTime? createdAt;
  DateTime? updatedAt;

  ChatMessage({
    required this.id,
    required this.message,
    this.data,
    required this.agentName,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      message: json['message'],
      data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
      agentName: json['agentName'] ?? 'user',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'data': data,
      'agentName': agentName,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
