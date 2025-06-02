part of 'msq_bloc.dart';

@immutable
abstract class MSQEvent extends Equatable {
  const MSQEvent();

  @override
  List<Object?> get props => [];
}

class FetchMSQs extends MSQEvent {
  final String bankId;

  const FetchMSQs(this.bankId);

  @override
  List<Object?> get props => [bankId];
}

class CreateMSQ extends MSQEvent {
  final MSQ msq;

  const CreateMSQ(this.msq);

  @override
  List<Object?> get props => [msq];
}

class UpdateMSQ extends MSQEvent {
  final String id;
  final MSQ msq;

  const UpdateMSQ(this.id, this.msq);

  @override
  List<Object?> get props => [id, msq];
}

class DeleteMSQ extends MSQEvent {
  final String id;

  const DeleteMSQ(this.id);

  @override
  List<Object?> get props => [id];
}

class SaveBulkMSQs extends MSQEvent {
  final List<MSQ> msqs;

  const SaveBulkMSQs(this.msqs);

  @override
  List<Object?> get props => [msqs];
}