import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../constants/app_constants.dart';

class QuestionSegmentationRepository {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.microserviceDomain,
    ),
  );

  final Dio _backendClient = Dio(
    BaseOptions(
      baseUrl: AppConstants.backendDomain,
    ),
  );

  final Logger _logger = Logger();

  Future<Response> segmentQuestion(String question) async {
    try {
      return await _client.post(
        '/segment-question',
        data: {
          'question': question,
        },
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error segmenting question: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> overrideQuestion(String questionId, String questionType, List<String> segmentedQuestions) async {
    try {
      // Create a multi-part question text
      String multiPartQuestion = _formatMultiPartQuestion(segmentedQuestions);

      // Use PATCH to update the question
      String endpoint = '/${questionType.toLowerCase()}s/$questionId';
      
      return await _backendClient.patch(
        endpoint,
        data: {
          'question': multiPartQuestion,
        },
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error overriding question: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  Future<Response> addQuestionWithParts(String questionType, String bankId, List<String> segmentedQuestions, Map<String, dynamic> questionData) async {
    try {
      // Create a multi-part question text
      String multiPartQuestion = _formatMultiPartQuestion(segmentedQuestions);

      // Create the question data with multi-part question
      Map<String, dynamic> newQuestionData = Map.from(questionData);
      newQuestionData['question'] = multiPartQuestion;
      newQuestionData['bankId'] = bankId;

      // Use POST to create a new question
      String endpoint = '/${questionType.toLowerCase()}s';
      
      return await _backendClient.post(
        endpoint,
        data: newQuestionData,
      );
    } on DioException catch (dioError, stackTrace) {
      _logger.e(
        'Error adding question with parts: Status code ${dioError.response?.statusCode}',
        error: dioError,
        stackTrace: stackTrace,
      );
      return dioError.response!;
    }
  }

  String _formatMultiPartQuestion(List<String> segmentedQuestions) {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < segmentedQuestions.length; i++) {
      buffer.write('${i + 1}. ${segmentedQuestions[i]}');
      if (i < segmentedQuestions.length - 1) {
        buffer.write('\n\n');
      }
    }
    return buffer.toString();
  }
} 