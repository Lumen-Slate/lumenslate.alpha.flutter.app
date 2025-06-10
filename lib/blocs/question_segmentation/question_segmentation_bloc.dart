import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import '../../repositories/ai/question_segmentation_repository.dart';

part 'question_segmentation_event.dart';
part 'question_segmentation_state.dart';

class QuestionSegmentationBloc extends Bloc<QuestionSegmentationEvent, QuestionSegmentationState> {
  final QuestionSegmentationRepository questionSegmentationRepository;

  QuestionSegmentationBloc(this.questionSegmentationRepository) : super(QuestionSegmentationInitial()) {
    on<SegmentQuestion>(_onSegmentQuestion);
    on<QuestionSegmentationReset>(_onQuestionSegmentationReset);
    on<OverrideQuestionWithParts>(_onOverrideQuestionWithParts);
    on<AddQuestionWithParts>(_onAddQuestionWithParts);
  }

  Future<void> _onSegmentQuestion(
    SegmentQuestion event,
    Emitter<QuestionSegmentationState> emit,
  ) async {
    emit(QuestionSegmentationLoading());
    try {
      final Response response = await questionSegmentationRepository.segmentQuestion(event.question);

      if (response.statusCode! >= 400) {
        throw StateError(response.data['error'] ?? 'An error occurred while segmenting the question.');
      }

      // Handle the actual response format from FastAPI microservice
      // The API returns segmentedQuestion as a single string
      String segmentedText = response.data['segmentedQuestion'] ?? '';
      
      // Split the text by lines to create individual segments
      List<String> segmentedQuestions = segmentedText
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.trim())
          .toList();

      emit(QuestionSegmentationSuccess(segmentedQuestions));
    } on StateError catch (e) {
      emit(QuestionSegmentationFailure(e.message));
    } on DioException catch (e) {
      emit(QuestionSegmentationFailure("Network error: ${e.message}"));
    } catch (e) {
      Logger().e('Error segmenting question: $e');
      emit(QuestionSegmentationFailure("Unexpected error: $e"));
    }
  }

  Future<void> _onQuestionSegmentationReset(
    QuestionSegmentationReset event,
    Emitter<QuestionSegmentationState> emit,
  ) async {
    emit(QuestionSegmentationInitial());
  }

  Future<void> _onOverrideQuestionWithParts(
    OverrideQuestionWithParts event,
    Emitter<QuestionSegmentationState> emit,
  ) async {
    emit(QuestionOverrideLoading());
    try {
      final Response response = await questionSegmentationRepository.overrideQuestion(
        event.questionId,
        event.questionType,
        event.segmentedQuestions,
      );

      if (response.statusCode! >= 400) {
        throw StateError(response.data['error'] ?? 'An error occurred while overriding the question.');
      }

      emit(QuestionOverrideSuccess('Question successfully overridden with multiple parts.'));
    } on StateError catch (e) {
      emit(QuestionOverrideFailure(e.message));
    } on DioException catch (e) {
      emit(QuestionOverrideFailure("Network error: ${e.message}"));
    } catch (e) {
      Logger().e('Error overriding question: $e');
      emit(QuestionOverrideFailure("Unexpected error: $e"));
    }
  }

  Future<void> _onAddQuestionWithParts(
    AddQuestionWithParts event,
    Emitter<QuestionSegmentationState> emit,
  ) async {
    emit(AddQuestionLoading());
    try {
      final Response response = await questionSegmentationRepository.addQuestionWithParts(
        event.questionType,
        event.bankId,
        event.segmentedQuestions,
        event.questionData,
      );

      if (response.statusCode! >= 400) {
        throw StateError(response.data['error'] ?? 'An error occurred while adding the question.');
      }

      emit(AddQuestionSuccess('New question with multiple parts successfully added.'));
    } on StateError catch (e) {
      emit(AddQuestionFailure(e.message));
    } on DioException catch (e) {
      emit(AddQuestionFailure("Network error: ${e.message}"));
    } catch (e) {
      Logger().e('Error adding question: $e');
      emit(AddQuestionFailure("Unexpected error: $e"));
    }
  }
}


