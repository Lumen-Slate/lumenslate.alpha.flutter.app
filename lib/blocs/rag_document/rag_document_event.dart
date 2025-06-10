part of 'rag_document_bloc.dart';

@immutable
sealed class RagDocumentEvent {}

class FetchRagDocuments extends RagDocumentEvent {
  final String teacherId;
  FetchRagDocuments({required this.teacherId});
}
