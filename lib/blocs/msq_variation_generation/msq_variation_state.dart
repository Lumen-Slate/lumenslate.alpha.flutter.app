part of 'msq_variation_bloc.dart';

@immutable
sealed class MSQVariationState extends Equatable {
  const MSQVariationState();

  @override
  List<Object?> get props => [];
}

class MSQVariationInitial extends MSQVariationState {}

class MSQVariationLoading extends MSQVariationState {}

class MSQVariationSuccess extends MSQVariationState {
  final List<MSQ> variations;

  const MSQVariationSuccess(this.variations);

  @override
  List<Object> get props => [variations];
}

class MSQVariationError extends MSQVariationState {
  final String error;
  final int? statusCode;

  const MSQVariationError(this.error, {this.statusCode});

  @override
  List<Object?> get props => [error, statusCode];
}