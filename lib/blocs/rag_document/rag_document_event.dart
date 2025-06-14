part of 'rag_document_bloc.dart';

@immutable
sealed class RagDocumentEvent {}


class AddCorpusDocument extends RagDocumentEvent {
  final String corpusName;
  final String fileLink;
  AddCorpusDocument({
    required this.corpusName,
    required this.fileLink,
  });
}

class DeleteCorpusDocument extends RagDocumentEvent {
  final String corpusName;
  final String fileDisplayName;
  DeleteCorpusDocument({
    required this.corpusName,
    required this.fileDisplayName,
  });
}

class ListCorpusContent extends RagDocumentEvent {
  final String corpusName;
  ListCorpusContent({required this.corpusName});
}
