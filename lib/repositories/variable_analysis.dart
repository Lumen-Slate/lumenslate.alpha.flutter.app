import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';

class VariableAnalysisRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.backendDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response> detectVariables(dynamic question) async {
    try {
      return await _client.post(
        '/variable-analysis',
        data: question.toJson(),
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error detecting variables: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }
}
