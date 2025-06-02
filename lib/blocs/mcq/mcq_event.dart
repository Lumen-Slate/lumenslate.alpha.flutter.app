part of 'mcq_bloc.dart';

@immutable
abstract class MCQEvent extends Equatable {
  const MCQEvent();

  @override
  List<Object?> get props => [];
}

class FetchMCQs extends MCQEvent {
  final String bankId;

  const FetchMCQs(this.bankId);

  @override
  List<Object?> get props => [bankId];
}

class CreateMCQ extends MCQEvent {
  final MCQ mcq;

  const CreateMCQ(this.mcq);

  @override
  List<Object?> get props => [mcq];
}

class UpdateMCQ extends MCQEvent {
  final String id;
  final MCQ mcq;

  const UpdateMCQ(this.id, this.mcq);

  @override
  List<Object?> get props => [id, mcq];
}

class DeleteMCQ extends MCQEvent {
  final String id;

  const DeleteMCQ(this.id);

  @override
  List<Object?> get props => [id];
}

class SaveBulkMCQs extends MCQEvent {
  final List<MCQ> mcqs;

  const SaveBulkMCQs(this.mcqs);

  @override
  List<Object?> get props => [mcqs];
}
