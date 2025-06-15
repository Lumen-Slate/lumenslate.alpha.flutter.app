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
    try {
      return await _client.post(
        '/ai/agent',
        data: {
          'userId': teacherId,
          'message': message,
        },
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error calling agent: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response;
    } catch (e, stackTrace) {
      _logger.e('Unexpected error calling agent', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  Future<Response?> fetchChatHistory({
    required String teacherId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      return await _client.get(
        '/ai/agent/history',
        queryParameters: {
          'userId': teacherId,
          'limit': limit,
          'offset': offset,
        },
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching chat history: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response;
    } catch (e, stackTrace) {
      _logger.e('Unexpected error fetching chat history', error: e, stackTrace: stackTrace);
      return null;
    }
  }
}
