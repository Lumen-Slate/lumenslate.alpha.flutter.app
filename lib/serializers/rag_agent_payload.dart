import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class RAGAgentPayload {
  final PlatformFile? file;
  final String teacherId;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;


  RAGAgentPayload({
    this.file,
    required this.teacherId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });


  FormData toFormData() {
    return FormData.fromMap({
      'file': file != null ? MultipartFile.fromBytes(file!.bytes!, filename: file!.name) : null,
      'teacherId': teacherId,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    });
  }
}