import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../constants/app_constants.dart';

class AIRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.microserviceDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response> generateContext(String question, List<String> keywords) async {
    final payload = {
      'question': question,
      'keywords': keywords,
    };

    try {
      return await _client.post('/generate-context', data: payload);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error generating context: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }
}
