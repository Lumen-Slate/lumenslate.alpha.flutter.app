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
        final response = await repository.getSubjectives(bankId: event.bankId);

        if (response.statusCode! >= 400) {
          throw StateError(response.data['error'] ?? 'Failed to fetch Subjectives.');
        }

        final subjectives = (response.data as List)
            .map((item) => Subjective.fromJson(item as Map<String, dynamic>))
            .toList();

        emit(SubjectiveLoaded(subjectives));
      } catch (e) {
        emit(SubjectiveError(e.toString()));
      }
    });

    on<CreateSubjective>((event, emit) async {
      try {
        final response = await repository.createSubjective(event.subjective);

        if (response.statusCode! >= 400) {
          throw StateError(response.data['error'] ?? 'Failed to create Subjective.');
        }

        add(FetchSubjectives(event.subjective.bankId));
      } catch (e) {
        emit(SubjectiveError(e.toString()));
      }
    });

    on<UpdateSubjective>((event, emit) async {
      try {
        final response = await repository.updateSubjective(event.id, event.subjective);

        if (response.statusCode! >= 400) {
          throw StateError(response.data['error'] ?? 'Failed to update Subjective.');
        }

        add(FetchSubjectives(event.subjective.bankId));
      } catch (e) {
        emit(SubjectiveError(e.toString()));
      }
    });

    on<DeleteSubjective>((event, emit) async {
      try {
        final response = await repository.deleteSubjective(event.id);

        if (response.statusCode! >= 400) {
          throw StateError(response.data['error'] ?? 'Failed to delete Subjective.');
        }

        add(FetchSubjectives(event.id));
      } catch (e) {
        emit(SubjectiveError(e.toString()));
      }
    });

    on<SaveBulkSubjectives>((event, emit) async {
      emit(SubjectiveLoading());
      try {
        final response = await repository.createBulkSubjectives(event.subjectives);

        if (response.statusCode! >= 400) {
          throw StateError(response.data['error'] ?? 'Failed to save bulk Subjectives.');
        }

        final subjectives = (response.data as List)
            .map((item) => Subjective.fromJson(item as Map<String, dynamic>))
            .toList();

        emit(SubjectiveLoaded(subjectives));
      } catch (e) {
        emit(SubjectiveError(e.toString()));
      }
    });
  }
}