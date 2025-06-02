import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import '../../repositories/variable_analysis.dart';

part 'variable_analysis_event.dart';
part 'variable_analysis_state.dart';

class VariableAnalysisBloc extends Bloc<VariableAnalysisEvent, VariableAnalysisState> {
  final VariableAnalysisRepository repository;

  VariableAnalysisBloc(this.repository) : super(VariableAnalysisInitial()) {
    on<DetectVariables>((event, emit) async {
      emit(VariableAnalysisLoading());
      try {
        final response = await repository.detectVariables(event.question);

        if (response.statusCode! >= 400) {
          throw DioException(
            requestOptions: RequestOptions(),
            response: response,
            message: response.data['error'] ?? 'Failed to detect variables.',
          );
        }

        emit(VariableAnalysisSuccess(response.data));
      } on DioException catch (e) {
        emit(VariableAnalysisFailure(e.message!, statusCode: e.response?.statusCode));
      } catch (e) {
        emit(VariableAnalysisFailure(e.toString()));
      }
    });
  }
}
