import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:lumen_slate/constants/app_constants.dart';

class AgentRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.backendDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response?> callAgent({
    required String teacherId,
    required String message,
  }) async {
    // Dummy response for testing
    await Future.delayed(const Duration(milliseconds: 300));
    return Response(
      requestOptions: RequestOptions(path: '/ai/agent'),
      statusCode: 200,
      data: {
        'id': 'dummy_id',
        'message': 'Dummy agent reply to: $message',
        'data': null,
        'agentName': 'agent',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
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
      data: List.generate(
        limit,
        (i) => {
          'id': 'dummy_id_${offset + i}',
          'message': 'Dummy message #${offset + i}',
          'data': null,
          'agentName': (i % 2 == 0) ? 'agent' : 'user',
          'createdAt': DateTime.now().subtract(Duration(minutes: offset + i)).toIso8601String(),
          'updatedAt': DateTime.now().subtract(Duration(minutes: offset + i)).toIso8601String(),
        },
      ),
    );
  }
}