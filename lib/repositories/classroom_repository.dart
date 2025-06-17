import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';
import '../models/classroom.dart';

class ClassroomRepository {
  final Dio _client = Dio(BaseOptions(baseUrl: AppConstants.backendDomain));

  final Logger _logger = Logger();

  Future<Response> createClassroom(Classroom classroom) async {
    try {
      return await _client.post('/classrooms', data: classroom.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error creating Classroom: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getClassrooms({
    required String teacherId,
    int limit = 10,
    int offset = 0,
    bool extended = false,
  }) async {
    try {
      Map<String, dynamic> queryParams = {'extended': extended.toString()};
      return await _client.get('/classrooms', queryParameters: queryParams);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching Classrooms: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getClassroom({required String id, bool extended = false}) async {
    try {
      return await _client.get('/classrooms/$id', queryParameters: {'extended': extended.toString()});
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching Classroom: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> updateClassroom(String id, Classroom classroom) async {
    try {
      return await _client.put('/classrooms/$id', data: classroom.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error updating Classroom: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> patchClassroom(String id, Map<String, dynamic> updates) async {
    try {
      return await _client.patch('/classrooms/$id', data: updates);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error patching Classroom: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> deleteClassroom(String id) async {
    try {
      return await _client.delete('/classrooms/$id');
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error deleting Classroom: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }
}
