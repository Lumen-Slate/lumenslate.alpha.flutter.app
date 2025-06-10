import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';
import '../models/questions/nat.dart';

class NATRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.backendDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response> createNAT(NAT nat) async {
    try {
      return await _client.post('/nats', data: nat.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error creating NAT: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getNATs({String? bankId, int limit = 10, int offset = 0}) async {
    try {
      Map<String, dynamic> queryParams = {
        'limit': limit.toString(),
        'offset': offset.toString(),
      };
      if (bankId != null) {
        queryParams['bankId'] = bankId;
      }
      return await _client.get('/nats', queryParameters: queryParams);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching NATs: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> updateNAT(String id, NAT nat) async {
    try {
      return await _client.put('/nats/$id', data: nat.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error updating NAT: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> patchNAT(String id, Map<String, dynamic> updates) async {
    try {
      return await _client.patch('/nats/$id', data: updates);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error patching NAT: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> deleteNAT(String id) async {
    try {
      return await _client.delete('/nats/$id');
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error deleting NAT: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> createBulkNATs(List<NAT> nats) async {
    try {
      return await _client.post(
        '/nats/bulk',
        data: nats.map((nat) => nat.toJson()).toList(),
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error creating bulk NATs: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }
}