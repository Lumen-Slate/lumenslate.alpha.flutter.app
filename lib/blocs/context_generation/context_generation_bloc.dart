import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
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
}