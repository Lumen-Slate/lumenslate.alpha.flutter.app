import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:lumen_slate/models/lumen_user.dart';
import '../constants/app_constants.dart';

class UserRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.backendDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response> createUser(Map<String,dynamic> data) async {
    try {
      return await _client.post('/users/', data: data);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error creating user: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getUser(String id) async {
    try {
      return await _client.get('/users/$id');
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching user: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> deleteUser(String id) async {
    try {
      return await _client.delete('/users/$id');
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error deleting user: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> getAllUsers(Map<String, String> filters) async {
    try {
      return await _client.get('/users/', queryParameters: filters);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error fetching users: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> updateUser(LumenUser user) async {
    try {
      return await _client.put('/users/${user.id}', data: user.toJson());
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error updating teacher: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> patchUser(String id, Map<String, dynamic> updates) async {
    try {
      return await _client.patch('/users/$id', data: updates);
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error patching user: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }
}