import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';
import '../models/classroom.dart';

class ClassroomRepository {
  final Dio _client = Dio(BaseOptions(baseUrl: AppConstants.backendDomain));

  final Logger _logger = Logger();

  Future<Response> createClassroom(Classroom classroom) async {
    try {
      // Ensure teacherIds is sent as a list
      final data = classroom.toJson();
      data['teacherIds'] = classroom.teacherIds;
      return await _client.post('/classrooms', data: data);
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
    required List<String> teacherIds,
    int limit = 10,
    int offset = 0,
    bool extended = false,
  }) async {
    try {
      Map<String, dynamic> queryParams = {
        'teacherIds': teacherIds,
        'limit': limit.toString(),
        'offset': offset.toString(),
        'extended': extended.toString()
      };
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
      final data = classroom.toJson();
      data['teacherIds'] = classroom.teacherIds;
      return await _client.put('/classrooms/$id', data: data);
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
