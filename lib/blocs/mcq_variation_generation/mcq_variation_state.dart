part of 'mcq_variation_bloc.dart';

abstract class MCQVariationState extends Equatable {
  const MCQVariationState();

  @override
  List<Object> get props => [];
}

class MCQVariationInitial extends MCQVariationState {}

class MCQVariationLoading extends MCQVariationState {}

class MCQVariationSuccess extends MCQVariationState {
  final List<MCQ> variations;

  const MCQVariationSuccess(this.variations);

  @override
  List<Object> get props => [variations];
}

class MCQVariationError extends MCQVariationState {
  final String error;
  final int? statusCode;

  const MCQVariationError(this.error, {this.statusCode});

  @override
  List<Object> get props => [error];
}