import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../../../../models/questions/mcq.dart';
import '../../repositories/ai/variation_generator.dart';

part 'mcq_variation_event.dart';

part 'mcq_variation_state.dart';

class MCQVariationBloc extends Bloc<MCQVariationEvent, MCQVariationState> {
  final VariationRepository mcqVariationRepository;

  MCQVariationBloc(this.mcqVariationRepository) : super(MCQVariationInitial()) {
    on<GenerateMCQVariations>(_onGenerateMCQVariations);
    on<MCQVariationReset>(_onMCQVariationReset);
  }

  Future<void> _onGenerateMCQVariations(
    GenerateMCQVariations event,
    Emitter<MCQVariationState> emit,
  ) async {
    emit(MCQVariationLoading());
    try {
      final Response response = await mcqVariationRepository.generateMCQVariations(event.mcq);

      if (response.statusCode! >= 400) {
        throw StateError(response.data['error'] ?? 'An error occurred while generating MCQ variations.');
      }

      List<MCQ> variations = response.data['variations']
          .map<MCQ>((item) => MCQ.fromJson({
                ...item as Map<String, dynamic>,
                "id": Uuid().v4(),
                "bankId": event.mcq.bankId,
                "variableIds": [],
                "points": event.mcq.points,
              }))
          .toList();

      emit(MCQVariationSuccess(variations));
    } on StateError catch (e) {
      emit(MCQVariationFailure(e.message));
    } on DioException catch (e) {
      emit(MCQVariationFailure("Network error: ${e.message}"));
    } catch (e) {
      Logger().e('Error generating MCQ variations: $e');
      emit(MCQVariationFailure("Unexpected error: $e"));
    }
  }

  Future<void> _onMCQVariationReset(
    MCQVariationReset event,
    Emitter<MCQVariationState> emit,
  ) async {
    emit(MCQVariationInitial());
  }
}
