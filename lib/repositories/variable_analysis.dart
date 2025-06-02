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

  Future<Map<String, dynamic>> detectVariables(dynamic question) async {
    try {
      final response = await _client.post(
        '/variable-analysis',
        data: question.toJson(),
      );
      return response.data;
    } catch (e) {
      _logger.e('Error detecting variables: $e');
      return {};
    }
  }
}