import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';
import '../models/teacher.dart';

class TeacherRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.backendDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response> createTeacher(Teacher teacher) async {
    try {
      return await _client.post('/teachers', data: teacher.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error creating teacher: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getTeacher(String id) async {
    try {
      return await _client.get('/teachers/$id');
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching teacher: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> deleteTeacher(String id) async {
    try {
      return await _client.delete('/teachers/$id');
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error deleting teacher: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getAllTeachers(Map<String, String> filters) async {
    try {
      return await _client.get('/teachers', queryParameters: filters);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching teachers: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> updateTeacher(String id, Teacher teacher) async {
    try {
      return await _client.put('/teachers/$id', data: teacher.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error updating teacher: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> patchTeacher(String id, Map<String, dynamic> updates) async {
    try {
      return await _client.patch('/teachers/$id', data: updates);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error patching teacher: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }
}