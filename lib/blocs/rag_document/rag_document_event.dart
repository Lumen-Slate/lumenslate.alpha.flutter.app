part of 'rag_document_bloc.dart';

@immutable
sealed class RagDocumentEvent {}

class AddCorpusDocument extends RagDocumentEvent {
  final String corpusName;
  final PlatformFile file;

  AddCorpusDocument({required this.corpusName, required this.file});
}

class DeleteCorpusDocument extends RagDocumentEvent {
  final String corpusName;
  final String id;

  DeleteCorpusDocument({required this.corpusName,required this.id});
}

class ListCorpusContent extends RagDocumentEvent {
  final String corpusName;

  ListCorpusContent({required this.corpusName});
}
