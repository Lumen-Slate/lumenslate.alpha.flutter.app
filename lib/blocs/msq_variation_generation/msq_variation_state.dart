part of 'msq_variation_bloc.dart';

@immutable
sealed class MSQVariationState extends Equatable {
  const MSQVariationState();

  @override
  List<Object> get props => [];
}

class MSQVariationInitial extends MSQVariationState {}

class MSQVariationLoading extends MSQVariationState {}

class MSQVariationSuccess extends MSQVariationState {
  final List<MSQ> variations;

  const MSQVariationSuccess(this.variations);

  @override
  List<Object> get props => [variations];
}

class MSQVariationFailure extends MSQVariationState {
  final String error;

  const MSQVariationFailure(this.error);

  @override
  List<Object> get props => [error];
}