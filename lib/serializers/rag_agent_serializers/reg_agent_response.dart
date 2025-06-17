import 'package:lumen_slate/serializers/rag_agent_serializers/rag_generated_questions_serializer.dart';

class RagAgentResponse {
  final String message;
  final String teacherId;
  final String agentName;
  final dynamic data;
  final String sessionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double responseTime;
  final String role;
  final String feedback;

  RagAgentResponse({
    required this.message,
    required this.teacherId,
    required this.agentName,
    required this.data,
    required this.sessionId,
    required this.createdAt,
    required this.updatedAt,
    required this.responseTime,
    required this.role,
    required this.feedback,
  });

  factory RagAgentResponse.fromJson(Map<String, dynamic> json) {

    final Map<String, dynamic>? dataMap = json['data'];
    dynamic data = dataMap;

    if (dataMap != null && dataMap.isNotEmpty) {
      data = RagGeneratedQuestionsSerializer.fromJson(dataMap);
    }

    return RagAgentResponse(
      message: json['message'] as String,
      teacherId: json['teacherId'] as String,
      agentName: json['agentName'] as String,
      data: data,
      sessionId: json['sessionId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      responseTime: double.tryParse(json['responseTime'].toString()) ?? 0.0,
      role: json['role'] as String,
      feedback: json['feedback'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'teacherId': teacherId,
      'agentName': agentName,
      'data': data.toJson(),
      'sessionId': sessionId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'responseTime': responseTime,
      'role': role,
      'feedback': feedback,
    };
  }
}
