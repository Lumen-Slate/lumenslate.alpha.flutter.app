part of 'variable_analysis_bloc.dart';

abstract class VariableAnalysisState extends Equatable {
  const VariableAnalysisState();

  @override
  List<Object?> get props => [];
}

class VariableAnalysisInitial extends VariableAnalysisState {}

class VariableAnalysisLoading extends VariableAnalysisState {}

class VariableAnalysisSuccess extends VariableAnalysisState {
  final dynamic data;

  const VariableAnalysisSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class VariableAnalysisFailure extends VariableAnalysisState {
  final String message;
  final int? statusCode;

  const VariableAnalysisFailure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}
