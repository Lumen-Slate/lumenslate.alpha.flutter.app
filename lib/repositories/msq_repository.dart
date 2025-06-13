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
      return await _client.post('/msqs', data: msq.toJson(forCreation: true));
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error creating MSQ: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getMSQs({String? bankId, int limit = 10, int offset = 0}) async {
    try {
      Map<String, dynamic> queryParams = {
        'limit': limit.toString(),
        'offset': offset.toString(),
      };
      if (bankId != null) {
        queryParams['bankId'] = bankId;
      }
      return await _client.get('/msqs', queryParameters: queryParams);
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
      return await _client.put('/msqs/$id', data: msq.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error updating MSQ: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> patchMSQ(String id, Map<String, dynamic> updates) async {
    try {
      return await _client.patch('/msqs/$id', data: updates);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error patching MSQ: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> deleteMSQ(String id) async {
    try {
      return await _client.delete('/msqs/$id');
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
        '/msqs/bulk',
        data: msqs.map((msq) => msq.toJson(forCreation: true)).toList(),
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