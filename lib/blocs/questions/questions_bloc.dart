import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

import '../../repositories/mcq_repository.dart';
import '../../repositories/msq_repository.dart';
import '../../repositories/nat_repository.dart';
import '../../repositories/subjective_repository.dart';
import '../../models/questions/mcq.dart';
import '../../models/questions/msq.dart';
import '../../models/questions/nat.dart';
import '../../models/questions/subjective.dart';

part 'questions_event.dart';
part 'questions_state.dart';

class QuestionsBloc extends Bloc<QuestionsEvent, QuestionsState> {
  final MCQRepository mcqRepository;
  final MSQRepository msqRepository;
  final NATRepository natRepository;
  final SubjectiveRepository subjectiveRepository;

  QuestionsBloc({
    required this.mcqRepository,
    required this.msqRepository,
    required this.natRepository,
    required this.subjectiveRepository,
  }) : super(QuestionsInitial()) {
    on<LoadQuestions>(_onLoadQuestions);
    on<QuestionsReset>(_onQuestionsReset);
  }

  Future<void> _onLoadQuestions(LoadQuestions event, Emitter<QuestionsState> emit) async {
    emit(QuestionsLoading());
    try {
      List<dynamic> allQuestions = [];

      // Load MCQs
      final mcqResponse = await mcqRepository.getMCQs(bankId: event.bankId, limit: event.limit, offset: event.offset);
      if (mcqResponse.statusCode! < 400) {
        final mcqList = (mcqResponse.data as List).map((item) => MCQ.fromJson(item as Map<String, dynamic>)).toList();
        allQuestions.addAll(mcqList);
      }

      // Load MSQs
      final msqResponse = await msqRepository.getMSQs(bankId: event.bankId, limit: event.limit, offset: event.offset);
      if (msqResponse.statusCode! < 400) {
        final msqList = (msqResponse.data as List).map((item) => MSQ.fromJson(item as Map<String, dynamic>)).toList();
        allQuestions.addAll(msqList);
      }

      // Load NATs
      final natResponse = await natRepository.getNATs(bankId: event.bankId, limit: event.limit, offset: event.offset);
      if (natResponse.statusCode! < 400) {
        final natList = (natResponse.data as List).map((item) => NAT.fromJson(item as Map<String, dynamic>)).toList();
        allQuestions.addAll(natList);
      }

      // Load Subjectives
      final subjectiveResponse = await subjectiveRepository.getSubjectives(
        bankId: event.bankId,
        limit: event.limit,
        offset: event.offset,
      );
      if (subjectiveResponse.statusCode! < 400) {
        final subjectiveList = (subjectiveResponse.data as List)
            .map((item) => Subjective.fromJson(item as Map<String, dynamic>))
            .toList();
        allQuestions.addAll(subjectiveList);
      }

      emit(QuestionsLoaded(allQuestions));
    } on DioException catch (e) {
      emit(QuestionsFailure("Network error: ${e.message}"));
    } catch (e) {
      Logger().e('Error loading questions: $e');
      emit(QuestionsFailure("Unexpected error: $e"));
    }
  }

  Future<void> _onQuestionsReset(QuestionsReset event, Emitter<QuestionsState> emit) async {
    emit(QuestionsInitial());
  }
}
