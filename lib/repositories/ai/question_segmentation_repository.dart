import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../constants/app_constants.dart';

class QuestionSegmentationRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.microserviceDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response> segmentQuestion(String question) async {
    try {
      return await _client.post(
        '/segment-question',
        data: {
          'question': question,
        },
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error segmenting question: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }
} 