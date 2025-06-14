import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';
import '../models/students.dart';

class StudentRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.backendDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response> createStudent(Student student) async {
    try {
      return await _client.post('/students/', data: student.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error creating Student: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getStudents({
    int limit = 10,
    int offset = 0,
    bool extended = false,
  }) async {
    try {
      Map<String, dynamic> queryParams = {
        'limit': limit.toString(),
        'offset': offset.toString(),
        'extended': extended.toString(),
      };
      return await _client.get('/students', queryParameters: queryParams);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching Students: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getStudent({required String id, bool extended = false}) async {
    try {
      return await _client.get('/students/$id', queryParameters: {'extended': extended.toString()});
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching Student: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> updateStudent(String id, Student student) async {
    try {
      return await _client.put('/students/$id', data: student.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error updating Student: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> patchStudent(String id, Map<String, dynamic> updates) async {
    try {
      return await _client.patch('/students/$id', data: updates);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error patching Student: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> deleteStudent(String id) async {
    try {
      return await _client.delete('/students/$id');
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error deleting Student: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }
}

