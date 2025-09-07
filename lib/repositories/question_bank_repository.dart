import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';
import '../models/question_bank.dart';

class QuestionBankRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.backendDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response> createQuestionBank(QuestionBank questionBank) async {
    try {
      return await _client.post('/question-banks', data: questionBank.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error creating Question Bank: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getQuestionBanks({
    required String teacherId,
    int limit = 10,
    int offset = 0,
    String? searchQuery,
  }) async {
    try {
      Map<String, dynamic> queryParams = {
        'limit': limit.toString(),
        'offset': offset.toString(),
        'teacherId': teacherId,
      };
      
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['q'] = searchQuery;
      }
      return await _client.get('/question-banks', queryParameters: queryParams);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching Question Banks: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getQuestionBank(String id) async {
    try {
      return await _client.get('/question-banks/$id');
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching Question Bank: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> updateQuestionBank(String id, QuestionBank questionBank) async {
    try {
      return await _client.put('/question-banks/$id', data: questionBank.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error updating Question Bank: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> patchQuestionBank(String id, Map<String, dynamic> updates) async {
    try {
      return await _client.patch('/question-banks/$id', data: updates);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error patching Question Bank: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> deleteQuestionBank(String id) async {
    try {
      return await _client.delete('/question-banks/$id');
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error deleting Question Bank: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }
}
