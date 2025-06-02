part of 'nat_bloc.dart';

@immutable
abstract class NATState extends Equatable {
  const NATState();

  @override
  List<Object?> get props => [];
}

class NATInitial extends NATState {}

class NATLoading extends NATState {}

class NATLoaded extends NATState {
  final List<NAT> nats;

  const NATLoaded(this.nats);

  @override
  List<Object?> get props => [nats];
}

class NATError extends NATState {
  final String message;

  const NATError(this.message);

  @override
  List<Object?> get props => [message];
}
