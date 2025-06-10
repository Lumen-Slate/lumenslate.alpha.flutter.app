import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:lumen_slate/constants/app_constants.dart';

class RagAgentRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.backendDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response?> callRagAgent({
    required String teacherId,
    required String message,
  }) async {
    // Dummy response for testing
    await Future.delayed(const Duration(milliseconds: 300));
    return Response(
      requestOptions: RequestOptions(path: '/ai/rag_agent'),
      statusCode: 200,
      data: {
        'id': 'dummy_id',
        'message': 'Dummy RAG agent reply to: $message',
        'data': null,
        'agentName': 'rag_agent',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<Response?> fetchRagChatHistory({
    required String teacherId,
    int limit = 20,
    int offset = 0,
  }) async {
    // Dummy response for testing
    await Future.delayed(const Duration(milliseconds: 300));
    return Response(
      requestOptions: RequestOptions(path: '/ai/rag_agent/history'),
      statusCode: 200,
      data: [],
    );
  }

  Future<Response?> fetchFilesForTeacher({
    required String teacherId,
  }) async {
    // Dummy response for testing
    await Future.delayed(const Duration(milliseconds: 300));
    return Response(
      requestOptions: RequestOptions(path: '/ai/rag_agent/files'),
      statusCode: 200,
      data: [
        {
          'fileId': 'file1',
          'fileName': 'Document1.pdf',
          'uploadedAt': DateTime.now().toIso8601String(),
        },
        {
          'fileId': 'file2',
          'fileName': 'Notes.docx',
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      ],
    );
  }
}
