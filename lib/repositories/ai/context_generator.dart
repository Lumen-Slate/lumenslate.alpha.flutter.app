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

  Future<String> generateContext(String question, List<String> keywords) async {
    final payload = {
      'question': question,
      'keywords': keywords,
    };

    try {
      final response = await _client.post('/generate-context', data: payload);
      return response.data['response'].toString();
    } catch (e) {
      _logger.e('Error creating post: $e');
      return 'Error: $e';
    }
  }
}