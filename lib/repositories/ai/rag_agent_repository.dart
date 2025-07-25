import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:lumen_slate/constants/app_constants.dart';
import 'package:lumen_slate/serializers/rag_agent_serializers/add_file_payload.dart';
import '../../serializers/rag_agent_serializers/add_corpus_document_serializer.dart';
import '../../serializers/rag_agent_serializers/delete_corpus_document_serializer.dart';
import '../../serializers/rag_agent_serializers/list_corpus_content_serializer.dart';
import '../../serializers/rag_agent_serializers/rag_agent_payload.dart';

class RagAgentRepository {
  final Dio _client = Dio(BaseOptions(baseUrl: AppConstants.backendDomain));

  final Logger _logger = Logger();

  Future<Response?> callRagAgent({required RAGAgentPayload payload}) async {
    try {
      final response = await _client.post('/ai/rag-agent', data: payload.toJson());
      return response;
    } catch (e) {
      _logger.e('Error calling rag agent: $e');
      return null;
    }
  }

  Future<Response?> fetchRagChatHistory({required String teacherId, int limit = 20, int offset = 0}) async {
    // Dummy response for testing
    await Future.delayed(const Duration(milliseconds: 300));
    return Response(
      requestOptions: RequestOptions(path: '/ai/rag_agent/history'),
      statusCode: 200,
      data: [],
    );
  }

  Future<AddCorpusDocumentSerializer?> addCorpusDocument(AddCorpusFilePayload payload) async {
    try {
      final response = await _client.post('/ai/rag-agent/add-corpus-document', data: payload.toFormData());
      return AddCorpusDocumentSerializer.fromJson(response.data);
    } catch (e) {
      _logger.e('Error adding corpus document: $e');
      rethrow;
    }
  }

  Future<DeleteCorpusDocumentSerializer?> deleteCorpusDocument(String id) async {
    try {
      final response = await _client.delete('/ai/documents/$id');
      return DeleteCorpusDocumentSerializer.fromJson(response.data);
    } catch (e) {
      _logger.e('Error deleting corpus document: $e');
      rethrow;
    }
  }

  Future<ListCorpusContentSerializer?> listCorpusContent({required String corpusName}) async {
    try {
      final response = await _client.get('/ai/rag-agent/$corpusName/documents');
      return ListCorpusContentSerializer.fromJson(response.data);
    } catch (e) {
      _logger.e('Error listing corpus content: $e');
      rethrow;
    }
  }

  Future<Response> getFileUrl({required String id}) async {
    try {
      final response = await _client.get('/ai/documents/view/$id');
      return response;
    } catch (e) {
      _logger.e('Error getting file URL: $e');
      rethrow;
    }
  }
}
