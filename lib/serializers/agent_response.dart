import 'assignment_generator_general_serializer.dart';
import 'assignment_generator_tailored_serializer.dart';

class AgentResponse {
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

  AgentResponse({
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

  factory AgentResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] == null) {
      throw ArgumentError('Data field cannot be null');
    }

    final String agentName = json['agentName'] as String;
    final Map<String, dynamic> dataMap = json['data'] as Map<String, dynamic>;
    final dynamic data;

    if (agentName == 'assignment_generator_general') {
      data = AssignmentGeneratorGeneralSerializer.fromJson(dataMap);
    } else if (agentName == 'assignment_generator_tailored') {
      data = AssignmentGeneratorTailoredSerializer.fromJson(dataMap);
    } else {
      throw ArgumentError('Unknown agent name: $agentName');
    }

    return AgentResponse(
      message: json['message'] as String,
      teacherId: json['teacherId'] as String,
      agentName: json['agentName'] as String,
      data: data,
      sessionId: json['sessionId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      responseTime: (json['responseTime'] as num).toDouble(),
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
