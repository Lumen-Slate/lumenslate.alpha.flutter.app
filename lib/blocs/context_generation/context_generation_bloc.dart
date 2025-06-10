import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../constants/dummy_data/questions/mcq.dart';
import '../../../../constants/dummy_data/questions/msq.dart';
import '../../../../constants/dummy_data/questions/nat.dart';
import '../../../../constants/dummy_data/questions/subjective.dart';
import '../../../../repositories/ai/context_generator.dart';

part 'context_generation_event.dart';
part 'context_generation_state.dart';

class ContextGeneratorBloc extends Bloc<ContextGeneratorEvent, ContextGeneratorState> {
  final AIRepository aiRepository;

  ContextGeneratorBloc(this.aiRepository) : super(ContextGeneratorInitial()) {
    on<GenerateContext>(_onGenerateContext);
    on<SaveQuestion>(_onSaveQuestion);
    on<OverrideQuestionWithContext>(_onOverrideQuestionWithContext);
    on<SaveAsNewQuestionWithContext>(_onSaveAsNewQuestionWithContext);
  }

  Future<void> _onGenerateContext(
      GenerateContext event,
      Emitter<ContextGeneratorState> emit,
      ) async {
    emit(ContextGeneratorLoading());
    try {
      final response = await aiRepository.generateContext(event.question, event.keywords);
      emit(ContextGeneratorSuccess(response));
    } catch (e) {
      emit(ContextGeneratorFailure(e.toString()));
    }
  }

  Future<void> _onSaveQuestion(
      SaveQuestion event,
      Emitter<ContextGeneratorState> emit,
      ) async {
    emit(ContextGeneratorLoading());
    try {
      // Update the dummy data based on the type
      switch (event.type) {
        case 'MCQ':
          final index = dummyMCQs.indexWhere((item) => item.id == event.id);
          if (index != -1) {
            dummyMCQs[index] = dummyMCQs[index].copyWith(question: event.updatedQuestion);
          }
          break;
        case 'MSQ':
          final index = dummyMSQs.indexWhere((item) => item.id == event.id);
          if (index != -1) {
            dummyMSQs[index] = dummyMSQs[index].copyWith(question: event.updatedQuestion);
          }
          break;
        case 'NAT':
          final index = dummyNATs.indexWhere((item) => item.id == event.id);
          if (index != -1) {
            dummyNATs[index] = dummyNATs[index].copyWith(question: event.updatedQuestion);
          }
          break;
        case 'Subjective':
          final index = dummySubjectives.indexWhere((item) => item.id == event.id);
          if (index != -1) {
            dummySubjectives[index] = dummySubjectives[index].copyWith(question: event.updatedQuestion);
          }
          break;
      }
      emit(ContextGeneratorSuccess('Question updated successfully'));
    } catch (e) {
      emit(ContextGeneratorFailure(e.toString()));
    }
  }

  Future<void> _onOverrideQuestionWithContext(
    OverrideQuestionWithContext event,
    Emitter<ContextGeneratorState> emit,
  ) async {
    emit(QuestionOverrideLoading());
    try {
      final Response response = await aiRepository.overrideQuestionWithContext(
        event.questionId,
        event.questionType,
        event.contextualizedQuestion,
      );

      if (response.statusCode! >= 400) {
        throw StateError(response.data['error'] ?? 'An error occurred while overriding the question.');
      }

      emit(QuestionOverrideSuccess('Question successfully overridden with context.'));
    } on StateError catch (e) {
      emit(QuestionOverrideFailure(e.message));
    } on DioException catch (e) {
      emit(QuestionOverrideFailure("Network error: ${e.message}"));
    } catch (e) {
      Logger().e('Error overriding question with context: $e');
      emit(QuestionOverrideFailure("Unexpected error: $e"));
    }
  }

  Future<void> _onSaveAsNewQuestionWithContext(
    SaveAsNewQuestionWithContext event,
    Emitter<ContextGeneratorState> emit,
  ) async {
    emit(SaveAsNewQuestionLoading());
    try {
      final Response response = await aiRepository.saveAsNewQuestionWithContext(
        event.questionType,
        event.bankId,
        event.contextualizedQuestion,
        event.questionData,
      );

      if (response.statusCode! >= 400) {
        throw StateError(response.data['error'] ?? 'An error occurred while saving the new question.');
      }

      emit(SaveAsNewQuestionSuccess('New question with context successfully saved.'));
    } on StateError catch (e) {
      emit(SaveAsNewQuestionFailure(e.message));
    } on DioException catch (e) {
      emit(SaveAsNewQuestionFailure("Network error: ${e.message}"));
    } catch (e) {
      Logger().e('Error saving new question with context: $e');
      emit(SaveAsNewQuestionFailure("Unexpected error: $e"));
    }
  }
}