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

      List<String> segmentedQuestions = (response.data['segmentedQuestions'] as List)
          .map<String>((item) => item.toString())
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
}


