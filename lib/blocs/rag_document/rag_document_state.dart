part of 'rag_document_bloc.dart';

@immutable
sealed class RagDocumentState {}

final class RagDocumentInitial extends RagDocumentState {}

class RagDocumentLoading extends RagDocumentState {}

class RagDocumentSuccess extends RagDocumentState {
  final List<RagDocument> documents;
  RagDocumentSuccess(this.documents);
}

class RagDocumentFailure extends RagDocumentState {
  final String message;
  RagDocumentFailure(this.message);
}

class RagDocument {
  final String fileId;
  final String fileName;
  final DateTime uploadedAt;

  RagDocument({
    required this.fileId,
    required this.fileName,
    required this.uploadedAt,
  });

  factory RagDocument.fromJson(Map<String, dynamic> json) => RagDocument(
        fileId: json['fileId'] as String,
        fileName: json['fileName'] as String,
        uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      );
}
