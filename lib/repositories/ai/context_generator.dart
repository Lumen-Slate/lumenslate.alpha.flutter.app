import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../constants/app_constants.dart';

class AIRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.backendDomain,
    ),
  );

  final Dio _backendClient = Dio(
    BaseOptions(
      baseUrl: AppConstants.backendDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<String> generateContext(String question, List<String> keywords) async {
    final payload = {
      'question': question,
      'keywords': keywords,
    };

    try {
      final response = await _client.post('/ai/generate-context', data: payload);
      return response.data['content'].toString();
    } catch (e) {
      _logger.e('Error creating post: $e');
      return 'Error: $e';
    }
  }

  Future<Response> overrideQuestionWithContext(String questionId, String questionType, String contextualizedQuestion) async {
    try {
      // Use PATCH to update the question
      String endpoint = '/${questionType.toLowerCase()}s/$questionId';
      
      return await _backendClient.patch(
        endpoint,
        data: {
          'question': contextualizedQuestion,
        },
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error overriding question with context: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> saveAsNewQuestionWithContext(String questionType, String bankId, String contextualizedQuestion, Map<String, dynamic> questionData) async {
    try {
      // Create the question data with contextualized question
      Map<String, dynamic> newQuestionData = Map.from(questionData);
      newQuestionData['question'] = contextualizedQuestion;
      newQuestionData['bankId'] = bankId;

      // Debug logging
      _logger.d('Saving as new question with context:');
      _logger.d('Question type: $questionType');
      _logger.d('Bank ID: $bankId');
      _logger.d('Contextualized question: $contextualizedQuestion');
      _logger.d('Full request data: $newQuestionData');

      // Use POST to create a new question
      String endpoint = '/${questionType.toLowerCase()}s';
      _logger.d('Endpoint: $endpoint');
      
      return await _backendClient.post(
        endpoint,
        data: newQuestionData,
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error saving as new question with context: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      if (dioError.response?.data != null) {
        _logger.e('Error response data: ${dioError.response?.data}');
      }
      return dioError.response!;
    }
  }
}