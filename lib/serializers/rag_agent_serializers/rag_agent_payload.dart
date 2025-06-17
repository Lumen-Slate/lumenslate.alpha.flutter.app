class RAGAgentPayload {
  final String? file;
  final String teacherId;
  final String role;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;

  RAGAgentPayload({
    this.file,
    required this.role,
    required this.teacherId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'file': file,
      'teacherId': teacherId,
      'role': role,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}