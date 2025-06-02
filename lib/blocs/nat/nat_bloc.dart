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
        final nats = await repository.getNATs(event.bankId);
        emit(NATLoaded(nats));
      } catch (e) {
        emit(NATError(e.toString()));
      }
    });

    on<CreateNAT>((event, emit) async {
      try {
        await repository.createNAT(event.nat);
        add(FetchNATs(event.nat.bankId));
      } catch (e) {
        emit(NATError(e.toString()));
      }
    });

    on<UpdateNAT>((event, emit) async {
      try {
        await repository.updateNAT(event.id, event.nat);
        add(FetchNATs(event.nat.bankId));
      } catch (e) {
        emit(NATError(e.toString()));
      }
    });

    on<DeleteNAT>((event, emit) async {
      try {
        await repository.deleteNAT(event.id);
        add(FetchNATs(event.id));
      } catch (e) {
        emit(NATError(e.toString()));
      }
    });
  }
}
