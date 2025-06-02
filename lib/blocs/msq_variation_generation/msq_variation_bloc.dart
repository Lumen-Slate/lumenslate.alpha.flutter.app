import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import '../../../../models/questions/msq.dart';
import '../../../../repositories/ai/variation_generator.dart';

part 'msq_variation_event.dart';
part 'msq_variation_state.dart';

class MSQVariationBloc extends Bloc<MSQVariationEvent, MSQVariationState> {
  final VariationRepository msqVariationRepository;

  MSQVariationBloc(this.msqVariationRepository) : super(MSQVariationInitial()) {
    on<GenerateMSQVariations>(_onGenerateMSQVariations);
    on<MSQVariationReset>(_onMSQVariationReset);
  }

  Future<void> _onGenerateMSQVariations(
      GenerateMSQVariations event,
      Emitter<MSQVariationState> emit,
      ) async {
    emit(MSQVariationLoading());
    try {
      final Response response = await msqVariationRepository.generateMSQVariations(event.msq);

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: RequestOptions(),
          response: response,
          message: response.data['error'] ?? "Failed to generate MSQ variations",
        );
      }

      List<MSQ> variations = response.data['variations']
          .map<MSQ>((item) => MSQ.fromJson({
        ...item as Map<String, dynamic>,
        "id": Uuid().v4(),
        "bankId": event.msq.bankId,
        "variableIds": [],
        "points": event.msq.points,
      }))
          .toList();

      emit(MSQVariationSuccess(variations));
    } on DioException catch (e) {
      emit(MSQVariationError(e.message!, statusCode: e.response?.statusCode));
    } catch (e) {
      emit(MSQVariationError(e.toString()));
    }
  }

  Future<void> _onMSQVariationReset(
      MSQVariationReset event,
      Emitter<MSQVariationState> emit,
      ) async {
    emit(MSQVariationInitial());
  }
}