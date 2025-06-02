part of 'variable_analysis_bloc.dart';

abstract class VariableAnalysisEvent extends Equatable {
  const VariableAnalysisEvent();

  @override
  List<Object?> get props => [];
}

class DetectVariables extends VariableAnalysisEvent {
  final dynamic question;

  const DetectVariables(this.question);

  @override
  List<Object?> get props => [question];
}
