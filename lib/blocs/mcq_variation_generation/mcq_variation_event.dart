part of 'mcq_variation_bloc.dart';

abstract class MCQVariationEvent extends Equatable {
  const MCQVariationEvent();

  @override
  List<Object> get props => [];
}

class GenerateMCQVariations extends MCQVariationEvent {
  final MCQ mcq;

  const GenerateMCQVariations(this.mcq);

  @override
  List<Object> get props => [mcq];
}

class MCQVariationReset extends MCQVariationEvent {
  const MCQVariationReset();

  @override
  List<Object> get props => [];
}
