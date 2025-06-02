part of 'nat_bloc.dart';

@immutable
abstract class NATEvent extends Equatable {
  const NATEvent();

  @override
  List<Object?> get props => [];
}

class FetchNATs extends NATEvent {
  final String bankId;

  const FetchNATs(this.bankId);

  @override
  List<Object?> get props => [bankId];
}

class CreateNAT extends NATEvent {
  final NAT nat;

  const CreateNAT(this.nat);

  @override
  List<Object?> get props => [nat];
}

class UpdateNAT extends NATEvent {
  final String id;
  final NAT nat;

  const UpdateNAT(this.id, this.nat);

  @override
  List<Object?> get props => [id, nat];
}

class DeleteNAT extends NATEvent {
  final String id;

  const DeleteNAT(this.id);

  @override
  List<Object?> get props => [id];
}
