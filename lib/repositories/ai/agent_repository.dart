import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:lumen_slate/constants/app_constants.dart';
import '../../serializers/agent_serializers/agent_payload.dart';

class AgentRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.backendDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response?> callAgent({
    required AgentPayload payload,
  }) async {
    try {
      final response = await _client.post(
        '/ai/agent',
        data: payload.toFormData(),
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
      return response;
    } catch (e) {
      _logger.e('Error calling agent: $e');
      return null;
    }
  }

  Future<Response?> fetchChatHistory({
    required String teacherId,
    int limit = 20,
    int offset = 0,
  }) async {
    // Dummy response for testing
    await Future.delayed(const Duration(milliseconds: 300));
    return Response(
      requestOptions: RequestOptions(path: '/ai/agent/history'),
      statusCode: 200,
      data: [],
    );
  }
}