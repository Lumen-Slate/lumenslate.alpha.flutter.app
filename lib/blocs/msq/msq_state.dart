part of 'msq_bloc.dart';

@immutable
abstract class MSQState extends Equatable {
  const MSQState();

  @override
  List<Object?> get props => [];
}

class MSQInitial extends MSQState {}

class MSQLoading extends MSQState {}

class MSQLoaded extends MSQState {
  final List<MSQ> msqs;

  const MSQLoaded(this.msqs);

  @override
  List<Object?> get props => [msqs];
}

class MSQError extends MSQState {
  final String message;

  const MSQError(this.message);

  @override
  List<Object?> get props => [message];
}
