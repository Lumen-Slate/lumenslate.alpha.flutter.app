part of 'subjective_bloc.dart';

@immutable
abstract class SubjectiveEvent extends Equatable {
  const SubjectiveEvent();

  @override
  List<Object?> get props => [];
}

class FetchSubjectives extends SubjectiveEvent {
  final String bankId;

  const FetchSubjectives(this.bankId);

  @override
  List<Object?> get props => [bankId];
}

class CreateSubjective extends SubjectiveEvent {
  final Subjective subjective;

  const CreateSubjective(this.subjective);

  @override
  List<Object?> get props => [subjective];
}

class UpdateSubjective extends SubjectiveEvent {
  final String id;
  final Subjective subjective;

  const UpdateSubjective(this.id, this.subjective);

  @override
  List<Object?> get props => [id, subjective];
}

class DeleteSubjective extends SubjectiveEvent {
  final String id;

  const DeleteSubjective(this.id);

  @override
  List<Object?> get props => [id];
}
