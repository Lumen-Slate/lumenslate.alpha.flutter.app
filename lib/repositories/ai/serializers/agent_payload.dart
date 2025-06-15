
class AgentPayload {
  final String message;
  final String userId;
  final String role;
  final String? file;
  final String? fileType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AgentPayload({
    required this.message,
    required this.userId,
    required this.role,
    this.file,
    this.fileType,
    this.createdAt,
    this.updatedAt,
  });

  factory AgentPayload.fromJson(Map<String, dynamic> json) {
    return AgentPayload(
      message: json['message'] as String,
      userId: json['userId'] as String,
      role: json['role'] as String,
      file: json['file'] as String?,
      fileType: json['fileType'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
      'role': role,
      if (file != null) 'file': file,
      if (fileType != null) 'fileType': fileType,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
