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
      return await _client.post('/subjective', data: subjective.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error creating Subjective: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getSubjectives(String bankId) async {
    try {
      return await _client.get('/subjective/bank/$bankId');
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
      return await _client.put('/subjective/$id', data: subjective.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error updating Subjective: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> deleteSubjective(String id) async {
    try {
      return await _client.delete('/subjective/$id');
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
        '/subjective/bulk',
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
