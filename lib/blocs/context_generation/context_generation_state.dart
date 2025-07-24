part of 'context_generation_bloc.dart';


abstract class ContextGeneratorState extends Equatable {
  const ContextGeneratorState();

  @override
  List<Object> get props => [];
}

class ContextGeneratorInitial extends ContextGeneratorState {}

class ContextGeneratorLoading extends ContextGeneratorState {}

class ContextGeneratorSuccess extends ContextGeneratorState {
  final String response;

  const ContextGeneratorSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class ContextGeneratorFailure extends ContextGeneratorState {
  final String error;

  const ContextGeneratorFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ContextOverwriteLoading extends ContextGeneratorState {}

class ContextOverwriteSuccess extends ContextGeneratorState {
  final String message;

  const ContextOverwriteSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ContextOverwriteFailure extends ContextGeneratorState {
  final String error;

  const ContextOverwriteFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ContextSaveAsNewLoading extends ContextGeneratorState {}

class ContextSaveAsNewSuccess extends ContextGeneratorState {
  final String message;

  const ContextSaveAsNewSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ContextSaveAsNewFailure extends ContextGeneratorState {
  final String error;

  const ContextSaveAsNewFailure(this.error);

  @override
  List<Object> get props => [error];
}