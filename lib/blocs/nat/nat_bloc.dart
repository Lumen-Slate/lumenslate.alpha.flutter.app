import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../models/questions/nat.dart';
import '../../../../repositories/nat_repository.dart';

part 'nat_event.dart';
part 'nat_state.dart';

class NATBloc extends Bloc<NATEvent, NATState> {
  final NATRepository repository;

  NATBloc(this.repository) : super(NATInitial()) {
    on<FetchNATs>((event, emit) async {
      emit(NATLoading());
      try {
        final response = await repository.getNATs(bankId: event.bankId);

        if (response.statusCode! >= 400) {
          throw StateError(response.data['error'] ?? 'Failed to fetch NATs.');
        }

        final nats = (response.data as List)
            .map((item) => NAT.fromJson(item as Map<String, dynamic>))
            .toList();

        emit(NATLoaded(nats));
      } catch (e) {
        emit(NATError(e.toString()));
      }
    });

    on<CreateNAT>((event, emit) async {
      try {
        final response = await repository.createNAT(event.nat);

        if (response.statusCode! >= 400) {
          throw StateError(response.data['error'] ?? 'Failed to create NAT.');
        }

        add(FetchNATs(event.nat.bankId));
      } catch (e) {
        emit(NATError(e.toString()));
      }
    });

    on<UpdateNAT>((event, emit) async {
      try {
        final response = await repository.updateNAT(event.id, event.nat);

        if (response.statusCode! >= 400) {
          throw StateError(response.data['error'] ?? 'Failed to update NAT.');
        }

        add(FetchNATs(event.nat.bankId));
      } catch (e) {
        emit(NATError(e.toString()));
      }
    });

    on<DeleteNAT>((event, emit) async {
      try {
        final response = await repository.deleteNAT(event.id);

        if (response.statusCode! >= 400) {
          throw StateError(response.data['error'] ?? 'Failed to delete NAT.');
        }

        add(FetchNATs(event.id));
      } catch (e) {
        emit(NATError(e.toString()));
      }
    });
  }
}
