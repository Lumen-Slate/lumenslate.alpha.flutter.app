import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../repositories/ai/rag_agent_repository.dart';
import '../../serializers/rag_agent_serializers/add_corpus_document_serializer.dart';
import '../../serializers/rag_agent_serializers/delete_corpus_document_serializer.dart';
import '../../serializers/rag_agent_serializers/list_corpus_content_serializer.dart';

part 'rag_document_event.dart';
part 'rag_document_state.dart';

class RagDocumentBloc extends Bloc<RagDocumentEvent, RagDocumentState> {
  final RagAgentRepository ragAgentRepository;

  RagDocumentBloc({required this.ragAgentRepository}) : super(RagDocumentInitial()) {

    on<AddCorpusDocument>((event, emit) async {
      emit(RagDocumentLoading());
      try {
        final result = await ragAgentRepository.addCorpusDocument(
          corpusName: event.corpusName,
          fileLink: event.fileLink,
        );
        emit(RagAddCorpusDocumentSuccess(result));
      } catch (e) {
        emit(RagDocumentFailure('Error adding document'));
      }
    });

    on<DeleteCorpusDocument>((event, emit) async {
      emit(RagDocumentLoading());
      try {
        final result = await ragAgentRepository.deleteCorpusDocument(
          corpusName: event.corpusName,
          fileDisplayName: event.fileDisplayName,
        );
        emit(RagDeleteCorpusDocumentSuccess(result));
      } catch (e) {
        emit(RagDocumentFailure('Error deleting document'));
      }
    });

    on<ListCorpusContent>((event, emit) async {
      emit(RagDocumentLoading());
      try {
        final result = await ragAgentRepository.listCorpusContent(
          corpusName: event.corpusName,
        );
        emit(RagListCorpusContentSuccess(result));
      } catch (e) {
        emit(RagDocumentFailure('Error listing corpus content'));
      }
    });
  }
}
