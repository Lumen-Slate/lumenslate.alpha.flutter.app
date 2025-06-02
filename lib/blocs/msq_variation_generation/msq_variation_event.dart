part of 'msq_variation_bloc.dart';

@immutable
sealed class MSQVariationEvent extends Equatable {
  const MSQVariationEvent();

  @override
  List<Object> get props => [];
}

class GenerateMSQVariations extends MSQVariationEvent {
  final MSQ msq;

  const GenerateMSQVariations(this.msq);

  @override
  List<Object> get props => [msq];
}

class MSQVariationReset extends MSQVariationEvent {
  const MSQVariationReset();

  @override
  List<Object> get props => [];
}