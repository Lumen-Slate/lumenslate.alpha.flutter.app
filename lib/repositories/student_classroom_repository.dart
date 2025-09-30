import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';

class StudentClassroomRepository {
  final Dio _client = Dio(BaseOptions(baseUrl: AppConstants.backendDomain));
  final Logger _logger = Logger();

  Future<Response> getStudentClassrooms({
    required String studentId,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      return await _client.get(
        '/students/$studentId/classrooms',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e('Error fetching student classrooms', error: dioError, stackTrace: stackTrace);
      return dioError.response!;
    }
  }

  Future<Response> joinClassroom({
    required String studentId,
    required String classroomCode,
  }) async {
    try {
      return await _client.post(
        '/students/$studentId/join-classroom',
        data: {'classroomCode': classroomCode},
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e('Error joining classroom', error: dioError, stackTrace: stackTrace);
      return dioError.response!;
    }
  }
}