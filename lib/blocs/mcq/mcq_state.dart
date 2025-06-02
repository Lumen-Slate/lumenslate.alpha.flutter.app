part of 'mcq_bloc.dart';

@immutable
abstract class MCQState extends Equatable {
  const MCQState();

  @override
  List<Object?> get props => [];
}

class MCQInitial extends MCQState {}

class MCQLoading extends MCQState {}

class MCQLoaded extends MCQState {
  final List<MCQ> mcqs;

  const MCQLoaded(this.mcqs);

  @override
  List<Object?> get props => [mcqs];
}

class MCQError extends MCQState {
  final String message;

  const MCQError(this.message);

  @override
  List<Object?> get props => [message];
}
