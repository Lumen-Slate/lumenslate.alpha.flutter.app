import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:lumen_slate/serializers/rag_agent_serializers/add_file_payload.dart';
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
      emit(RagDocumentAdding());
      try {
        final _ = await ragAgentRepository.addCorpusDocument(
          AddCorpusFilePayload(corpusName: event.corpusName, file: event.file),
        );
        add(ListCorpusContent(corpusName: event.corpusName));
      } catch (e) {
        emit(RagDocumentFailure('Error adding document'));
      }
    });

    on<DeleteCorpusDocument>((event, emit) async {
      emit(RagDocumentDeleting());
      try {
        final _ = await ragAgentRepository.deleteCorpusDocument(event.id);

        add(ListCorpusContent(corpusName: event.corpusName));
      } catch (e) {
        emit(RagDocumentFailure('Error deleting document'));
      }
    });

    on<ListCorpusContent>((event, emit) async {
      if (!event.async) {
        emit(RagDocumentsLoading());
      }
      try {
        final result = await ragAgentRepository.listCorpusContent(corpusName: event.corpusName);
        emit(RagListCorpusContentSuccess(result));
      } catch (e) {
        emit(RagDocumentFailure('Error listing corpus content'));
      }
    });
  }
}
