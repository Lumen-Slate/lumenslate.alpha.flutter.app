import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';
import '../models/questions/mcq.dart';

class MCQRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.backendDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response> createMCQ(MCQ mcq) async {
    try {
      return await _client.post('/mcq', data: mcq.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error creating MCQ: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getMCQs(String bankId) async {
    try {
      return await _client.get('/mcq/bank/$bankId');
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching MCQs: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> updateMCQ(String id, MCQ mcq) async {
    try {
      return await _client.put('/mcq/$id', data: mcq.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error updating MCQ: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> deleteMCQ(String id) async {
    try {
      return await _client.delete('/mcq/$id');
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error deleting MCQ: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> createBulkMCQs(List<MCQ> mcqs) async {
    try {
      return await _client.post(
        '/mcqs/bulk',
        data: mcqs.map((mcq) => mcq.toJson()).toList(),
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error creating bulk MCQs: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }
}