part of 'subjective_bloc.dart';

@immutable
abstract class SubjectiveState extends Equatable {
  const SubjectiveState();

  @override
  List<Object?> get props => [];
}

class SubjectiveInitial extends SubjectiveState {}

class SubjectiveLoading extends SubjectiveState {}

class SubjectiveLoaded extends SubjectiveState {
  final List<Subjective> subjectives;

  const SubjectiveLoaded(this.subjectives);

  @override
  List<Object?> get props => [subjectives];
}

class SubjectiveError extends SubjectiveState {
  final String message;

  const SubjectiveError(this.message);

  @override
  List<Object?> get props => [message];
}
