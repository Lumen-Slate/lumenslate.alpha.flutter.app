import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../models/questions/subjective.dart';
import '../../../../repositories/subjective_repository.dart';

part 'subjective_event.dart';
part 'subjective_state.dart';

class SubjectiveBloc extends Bloc<SubjectiveEvent, SubjectiveState> {
  final SubjectiveRepository repository;

  SubjectiveBloc(this.repository) : super(SubjectiveInitial()) {
    on<FetchSubjectives>((event, emit) async {
      emit(SubjectiveLoading());
      try {
        final subjectives = await repository.getSubjectives(event.bankId);
        emit(SubjectiveLoaded(subjectives));
      } catch (e) {
        emit(SubjectiveError(e.toString()));
      }
    });

    on<CreateSubjective>((event, emit) async {
      try {
        await repository.createSubjective(event.subjective);
        add(FetchSubjectives(event.subjective.bankId));
      } catch (e) {
        emit(SubjectiveError(e.toString()));
      }
    });

    on<UpdateSubjective>((event, emit) async {
      try {
        await repository.updateSubjective(event.id, event.subjective);
        add(FetchSubjectives(event.subjective.bankId));
      } catch (e) {
        emit(SubjectiveError(e.toString()));
      }
    });

    on<DeleteSubjective>((event, emit) async {
      try {
        await repository.deleteSubjective(event.id);
        add(FetchSubjectives(event.id));
      } catch (e) {
        emit(SubjectiveError(e.toString()));
      }
    });
  }
}