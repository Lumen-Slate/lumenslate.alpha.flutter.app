import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:lumen_slate/constants/app_constants.dart';
import '../../serializers/rag_agent_serializers/add_corpus_document_serializer.dart';
import '../../serializers/rag_agent_serializers/delete_corpus_document_serializer.dart';
import '../../serializers/rag_agent_serializers/list_corpus_content_serializer.dart';

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


  Future<AddCorpusDocumentSerializer?> addCorpusDocument({
    required String corpusName,
    required String fileLink
  }) async {
    try {
      final response = await _client.post(
        '/ai/rag-agent/add-corpus-document',
        data: {
          'corpusName': corpusName,
          'fileLink': fileLink,
        },
      );
      return AddCorpusDocumentSerializer.fromJson(response.data);
    } catch (e) {
      _logger.e('Error adding corpus document: $e');
      rethrow;
    }
  }

  Future<DeleteCorpusDocumentSerializer?> deleteCorpusDocument({
    required String corpusName,
    required String fileDisplayName,
  }) async {
    try {
      final response = await _client.post(
        '/ai/rag-agent/delete-corpus-document',
        data: {
          'corpusName': corpusName,
          'fileDisplayName': fileDisplayName,
        },
      );
      return DeleteCorpusDocumentSerializer.fromJson(response.data);
    } catch (e) {
      _logger.e('Error deleting corpus document: $e');
      rethrow;
    }
  }

  Future<ListCorpusContentSerializer?> listCorpusContent({
    required String corpusName,
  }) async {
    try {
      final response = await _client.post(
        '/ai/rag-agent/list-corpus-content',
        data: {
          'corpusName': corpusName,
        },
      );
      return ListCorpusContentSerializer.fromJson(response.data);
    } catch (e) {
      _logger.e('Error listing corpus content: $e');
      rethrow;
    }
  }
}
