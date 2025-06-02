import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../models/questions/msq.dart';
import '../../../../repositories/msq_repository.dart';

part 'msq_event.dart';
part 'msq_state.dart';


class MSQBloc extends Bloc<MSQEvent, MSQState> {
  final MSQRepository repository;

  MSQBloc(this.repository) : super(MSQInitial()) {
    on<FetchMSQs>((event, emit) async {
      emit(MSQLoading());
      try {
        final response = await repository.getMSQs(event.bankId);

        if (response.statusCode! >= 400) {
          throw StateError(response.data['error'] ?? 'Failed to fetch MSQs.');
        }

        final msqs = (response.data as List)
            .map((item) => MSQ.fromJson(item as Map<String, dynamic>))
            .toList();

        emit(MSQLoaded(msqs));
      } catch (e) {
        emit(MSQError(e.toString()));
      }
    });

    on<CreateMSQ>((event, emit) async {
      try {
        final response = await repository.createMSQ(event.msq);

        if (response.statusCode! >= 400) {
          throw StateError(response.data['error'] ?? 'Failed to create MSQ.');
        }

        add(FetchMSQs(event.msq.bankId)); // Reload MSQs
      } catch (e) {
        emit(MSQError(e.toString()));
      }
    });

    on<UpdateMSQ>((event, emit) async {
      try {
        final response = await repository.updateMSQ(event.id, event.msq);

        if (response.statusCode! >= 400) {
          throw StateError(response.data['error'] ?? 'Failed to update MSQ.');
        }

        add(FetchMSQs(event.msq.bankId));
      } catch (e) {
        emit(MSQError(e.toString()));
      }
    });

    on<DeleteMSQ>((event, emit) async {
      try {
        final response = await repository.deleteMSQ(event.id);

        if (response.statusCode! >= 400) {
          throw StateError(response.data['error'] ?? 'Failed to delete MSQ.');
        }

        add(FetchMSQs(event.id));
      } catch (e) {
        emit(MSQError(e.toString()));
      }
    });

    on<SaveBulkMSQs>((event, emit) async {
      emit(MSQLoading());
      try {
        final response = await repository.createBulkMSQs(event.msqs);

        if (response.statusCode! >= 400) {
          throw StateError(response.data['error'] ?? 'Failed to save bulk MSQs.');
        }

        final msqs = (response.data['msqs'] as List)
            .map((item) => MSQ.fromJson(item as Map<String, dynamic>))
            .toList();

        emit(MSQLoaded(msqs));
      } catch (e) {
        emit(MSQError(e.toString()));
      }
    });
  }
}