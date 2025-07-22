part of 'rag_document_bloc.dart';

@immutable
sealed class RagDocumentState {}

final class RagDocumentInitial extends RagDocumentState {}

class RagDocumentsLoading extends RagDocumentState {}

class RagDocumentAdding extends RagDocumentState {}

class RagDocumentDeleting extends RagDocumentState {}

class RagDocumentFailure extends RagDocumentState {
  final String message;

  RagDocumentFailure(this.message);
}

class RagAddCorpusDocumentSuccess extends RagDocumentState {
  final AddCorpusDocumentSerializer? response;

  RagAddCorpusDocumentSuccess(this.response);
}

class RagDeleteCorpusDocumentSuccess extends RagDocumentState {
  final DeleteCorpusDocumentSerializer? response;

  RagDeleteCorpusDocumentSuccess(this.response);
}

class RagListCorpusContentSuccess extends RagDocumentState {
  final ListCorpusContentSerializer? response;

  RagListCorpusContentSuccess(this.response);
}
