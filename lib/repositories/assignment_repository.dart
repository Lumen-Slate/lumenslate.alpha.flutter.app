import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';
import '../models/assignments.dart';

class AssignmentRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.backendDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response> createAssignment(Assignment assignment) async {
    try {
      return await _client.post('/assignments/', data: assignment.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error creating Assignment: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getAssignments({
    required String teacherId,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      Map<String, dynamic> queryParams = {
        'limit': limit.toString(),
        'offset': offset.toString()
      };
      return await _client.get('/assignments/', queryParameters: queryParams);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching Assignments: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getAssignment(String id) async {
    try {
      return await _client.get('/assignments/$id');
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching Assignment: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> updateAssignment(String id, Assignment assignment) async {
    try {
      return await _client.put('/assignments/$id', data: assignment.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error updating Assignment: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> patchAssignment(String id, Map<String, dynamic> updates) async {
    try {
      return await _client.patch('/assignments/$id', data: updates);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error patching Assignment: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> deleteAssignment(String id) async {
    try {
      return await _client.delete('/assignments/$id');
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error deleting Assignment: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }
}
