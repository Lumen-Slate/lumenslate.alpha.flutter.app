// lib/serializers/rag_agent_serializers/delete_corpus_document_serialzier.dart
class DeleteCorpusDocumentSerializer {
  final String documentId;
  final String message;

  DeleteCorpusDocumentSerializer({
    required this.documentId,
    required this.message,
  });

  factory DeleteCorpusDocumentSerializer.fromJson(Map<String, dynamic> json) {
    return DeleteCorpusDocumentSerializer(
      documentId: json['documentId'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'documentId': documentId, 'message': message};
  }
}
