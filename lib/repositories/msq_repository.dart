import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';
import '../models/questions/msq.dart';

class MSQRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.backendDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response> createMSQ(MSQ msq) async {
    try {
      return await _client.post('/msq', data: msq.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error creating MSQ: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getMSQs(String bankId) async {
    try {
      return await _client.get('/msq/bank/$bankId');
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching MSQs: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> updateMSQ(String id, MSQ msq) async {
    try {
      return await _client.put('/msq/$id', data: msq.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error updating MSQ: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> deleteMSQ(String id) async {
    try {
      return await _client.delete('/msq/$id');
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error deleting MSQ: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> createBulkMSQs(List<MSQ> msqs) async {
    try {
      return await _client.post(
        '/msq/bulk',
        data: msqs.map((msq) => msq.toJson()).toList(),
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error creating bulk MSQs: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }
}