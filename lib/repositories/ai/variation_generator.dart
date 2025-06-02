import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../constants/app_constants.dart';
import '../../models/questions/mcq.dart';
import '../../models/questions/msq.dart';

class VariationRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.microserviceDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response> generateMCQVariations(MCQ mcq) async {
    try {
      return await _client.post(
        '/generate-mcq-variations',
        data: {
          'question': mcq.question,
          'options': mcq.options,
          'answerIndex': mcq.answerIndex,
        },
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error generating MCQ variations: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> generateMSQVariations(MSQ msq) async {
    try {
      return await _client.post(
        '/generate-msq-variations',
        data: {
          'question': msq.question,
          'options': msq.options,
          'answerIndices': msq.answerIndices,
        },
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error generating MSQ variations: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }
}
