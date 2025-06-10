import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';
import '../models/questions/subjective.dart';

class SubjectiveRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.backendDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response> createSubjective(Subjective subjective) async {
    try {
      return await _client.post('/subjectives', data: subjective.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error creating Subjective: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getSubjectives({String? bankId, int limit = 10, int offset = 0}) async {
    try {
      Map<String, dynamic> queryParams = {
        'limit': limit.toString(),
        'offset': offset.toString(),
      };
      if (bankId != null) {
        queryParams['bankId'] = bankId;
      }
      return await _client.get('/subjectives', queryParameters: queryParams);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching Subjectives: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> updateSubjective(String id, Subjective subjective) async {
    try {
      return await _client.put('/subjectives/$id', data: subjective.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error updating Subjective: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> patchSubjective(String id, Map<String, dynamic> updates) async {
    try {
      return await _client.patch('/subjectives/$id', data: updates);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error patching Subjective: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> deleteSubjective(String id) async {
    try {
      return await _client.delete('/subjectives/$id');
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error deleting Subjective: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> createBulkSubjectives(List<Subjective> subjectives) async {
    try {
      return await _client.post(
        '/subjectives/bulk',
        data: subjectives.map((subjective) => subjective.toJson()).toList(),
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error creating bulk Subjectives: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }
}