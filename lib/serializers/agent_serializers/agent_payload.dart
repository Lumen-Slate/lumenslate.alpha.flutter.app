import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class AgentPayload {
  final PlatformFile? file;
  final String teacherId;
  final String role;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;

  AgentPayload({
    this.file,
    required this.teacherId,
    required this.role,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  FormData toFormData() {
    return FormData.fromMap({
      if (file != null)
        'file': MultipartFile.fromBytes(file!.bytes!, filename: file!.name),
      'teacherId': teacherId,
      'role': role,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    });
  }
}
