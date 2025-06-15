import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../constants/dummy_data/questions/mcq.dart';
import '../../../../constants/dummy_data/questions/msq.dart';
import '../../../../constants/dummy_data/questions/nat.dart';
import '../../../../constants/dummy_data/questions/subjective.dart';
import '../../../../repositories/ai/context_generator.dart';
import '../../../../repositories/mcq_repository.dart';
import '../../../../repositories/msq_repository.dart';
import '../../../../repositories/nat_repository.dart';
import '../../../../repositories/subjective_repository.dart';
import '../../../../models/questions/mcq.dart';
import '../../../../models/questions/msq.dart';
import '../../../../models/questions/nat.dart';
import '../../../../models/questions/subjective.dart';

part 'context_generation_event.dart';
part 'context_generation_state.dart';

class ContextGeneratorBloc extends Bloc<ContextGeneratorEvent, ContextGeneratorState> {
  final AIRepository aiRepository;
  final MCQRepository mcqRepository;
  final MSQRepository msqRepository;
  final NATRepository natRepository;
  final SubjectiveRepository subjectiveRepository;

  ContextGeneratorBloc(
    this.aiRepository,
    this.mcqRepository,
    this.msqRepository,
    this.natRepository,
    this.subjectiveRepository,
  ) : super(ContextGeneratorInitial()) {
    on<GenerateContext>(_onGenerateContext);
    on<ContextGeneratorReset>(_onContextGeneratorReset);
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

  Future<void> _onContextGeneratorReset(
    ContextGeneratorReset event,
    Emitter<ContextGeneratorState> emit,
  ) async {
    emit(ContextGeneratorInitial());
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
    emit(ContextOverrideLoading());
    try {
      final Response response = await aiRepository.overrideQuestionWithContext(
        event.questionId,
        event.questionType,
        event.contextualizedQuestion,
      );

      if (response.statusCode! >= 400) {
        throw StateError(response.data['error'] ?? 'An error occurred while overriding the question.');
      }

      emit(ContextOverrideSuccess('Question successfully overridden with context.'));
    } on StateError catch (e) {
      emit(ContextOverrideFailure(e.message));
    } on DioException catch (e) {
      emit(ContextOverrideFailure("Network error: ${e.message}"));
    } catch (e) {
      Logger().e('Error overriding question with context: $e');
      emit(ContextOverrideFailure("Unexpected error: $e"));
    }
  }

  Future<void> _onSaveAsNewQuestionWithContext(
    SaveAsNewQuestionWithContext event,
    Emitter<ContextGeneratorState> emit,
  ) async {
    emit(ContextSaveAsNewLoading());
    try {
      Response response;
      
      // Determine question type and use appropriate repository
      switch (event.questionType.toLowerCase()) {
        // TODO: remove dummy
        case 'mcq':
          final mcq = MCQ(
            id: '',
            subject: 'mathematics', // Dummy subject, replace with actual if needed
            difficulty: 'easy', // Dummy difficulty, replace with actual if needed
            bankId: event.bankId,
            question: event.contextualizedQuestion,
            variableIds: List<String>.from(event.questionData['variableIds'] ?? []),
            points: event.questionData['points'] ?? 5,
            options: List<String>.from(event.questionData['options'] ?? []),
            answerIndex: event.questionData['answerIndex'] ?? 0,
          );
          response = await mcqRepository.createMCQ(mcq);
          break;
          
        case 'msq':
          final msq = MSQ(
            id: '',
            subject: 'mathematics', // Dummy subject, replace with actual if needed
            difficulty: 'easy', // Dummy difficulty, replace with actual if needed
            bankId: event.bankId,
            question: event.contextualizedQuestion,
            variableIds: List<String>.from(event.questionData['variableIds'] ?? []),
            points: event.questionData['points'] ?? 5,
            options: List<String>.from(event.questionData['options'] ?? []),
            answerIndices: List<int>.from(event.questionData['answerIndices'] ?? [0]),
          );
          response = await msqRepository.createMSQ(msq);
          break;
          
        case 'nat':
          final nat = NAT(
            id: '',
            subject: 'mathematics', // Dummy subject, replace with actual if needed
            difficulty: 'easy', // Dummy difficulty, replace with actual if needed
            bankId: event.bankId,
            question: event.contextualizedQuestion,
            variableIds: List<String>.from(event.questionData['variableIds'] ?? []),
            points: event.questionData['points'] ?? 5,
            answer: (event.questionData['answer'] ?? 0.0).toDouble(),
          );
          response = await natRepository.createNAT(nat);
          break;
          
        case 'subjective':
          final subjective = Subjective(
            id: '',
            subject: 'mathematics', // Dummy subject, replace with actual if needed
            difficulty: 'easy', // Dummy difficulty, replace with actual if needed
            bankId: event.bankId,
            question: event.contextualizedQuestion,
            variableIds: List<String>.from(event.questionData['variableIds'] ?? []),
            points: event.questionData['points'] ?? 10,
            idealAnswer: event.questionData['idealAnswer'],
            gradingCriteria: event.questionData['gradingCriteria'] != null 
                ? List<String>.from(event.questionData['gradingCriteria'])
                : null,
          );
          response = await subjectiveRepository.createSubjective(subjective);
          break;
          
        default:
          throw StateError('Unsupported question type: ${event.questionType}');
      }

      if (response.statusCode! >= 400) {
        throw StateError(response.data['error'] ?? 'An error occurred while saving the new question.');
      }

      emit(ContextSaveAsNewSuccess('New question with context successfully saved.'));
    } on StateError catch (e) {
      emit(ContextSaveAsNewFailure(e.message));
    } on DioException catch (e) {
      emit(ContextSaveAsNewFailure("Network error: ${e.message}"));
    } catch (e) {
      Logger().e('Error saving new question with context: $e');
      emit(ContextSaveAsNewFailure("Unexpected error: $e"));
    }
  }
}