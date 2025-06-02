import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../models/questions/mcq.dart';
import '../../../../repositories/mcq_repository.dart';

part 'mcq_event.dart';
part 'mcq_state.dart';

class MCQBloc extends Bloc<MCQEvent, MCQState> {
  final MCQRepository repository;

  MCQBloc(this.repository) : super(MCQInitial()) {
    on<FetchMCQs>((event, emit) async {
      emit(MCQLoading());
      try {
        final response = await repository.getMCQs(event.bankId);

        if (response.statusCode! >= 400) {
          // throw StateError(response.data['error'] ?? 'Failed to fetch MCQs.');
          throw DioException(
            requestOptions: RequestOptions(),
            response: response,
            message: response.data['error'] ?? 'Failed to fetch MCQs.',
          );
        }

        final mcqs = (response.data as List).map((item) => MCQ.fromJson(item as Map<String, dynamic>)).toList();

        emit(MCQLoaded(mcqs));
      } on DioException catch (e) {
        emit(MCQError(e.message!, statusCode: e.response?.statusCode));
      } catch (e) {
        emit(MCQError(e.toString()));
      }
    });

    on<CreateMCQ>((event, emit) async {
      try {
        final response = await repository.createMCQ(event.mcq);

        if (response.statusCode! >= 400) {
          throw DioException(
            requestOptions: RequestOptions(),
            response: response,
            message: response.data['error'] ?? 'Failed to create MCQ.',
          );
        }

        add(FetchMCQs(event.mcq.bankId)); // Reload MCQs
      } on DioException catch (e) {
        emit(MCQError(e.message!, statusCode: e.response?.statusCode));
      } catch (e) {
        emit(MCQError(e.toString()));
      }
    });

    on<UpdateMCQ>((event, emit) async {
      try {
        final response = await repository.updateMCQ(event.id, event.mcq);

        if (response.statusCode! >= 400) {
          throw DioException(
            requestOptions: RequestOptions(),
            response: response,
            message: response.data['error'] ?? 'Failed to update MCQ.',
          );
        }

        add(FetchMCQs(event.mcq.bankId));
      } on DioException catch (e) {
        emit(MCQError(e.message!, statusCode: e.response?.statusCode));
      } catch (e) {
        emit(MCQError(e.toString()));
      }
    });

    on<DeleteMCQ>((event, emit) async {
      try {
        final response = await repository.deleteMCQ(event.id);

        if (response.statusCode! >= 400) {
          throw DioException(
            requestOptions: RequestOptions(),
            response: response,
            message: response.data['error'] ?? 'Failed to delete MCQ.',
          );
        }

        add(FetchMCQs(event.id));
      } on DioException catch (e) {
        emit(MCQError(e.message!, statusCode: e.response?.statusCode));
      } catch (e) {
        emit(MCQError(e.toString()));
      }
    });

    on<SaveBulkMCQs>((event, emit) async {
      emit(MCQLoading());
      try {
        final response = await repository.createBulkMCQs(event.mcqs);

        if (response.statusCode! >= 400) {
          throw DioException(
            requestOptions: RequestOptions(),
            response: response,
            message: response.data['error'] ?? 'Failed to save bulk MCQs.',
          );
        }

        final mcqs = (response.data['mcqs'] as List).map((item) => MCQ.fromJson(item as Map<String, dynamic>)).toList();

        emit(MCQLoaded(mcqs));
      } on DioException catch (e) {
        emit(MCQError(e.message!, statusCode: e.response?.statusCode));
      } catch (e) {
        emit(MCQError(e.toString()));
      }
    });
  }
}
