// lib/serializers/rag_agent_serializers/delete_corpus_document_serialzier.dart
class DeleteCorpusDocumentSerializer {
  final String corpusName;
  final String deletedFileName;
  final bool documentDeleted;
  final String message;
  final String operationName;
  final String status;

  DeleteCorpusDocumentSerializer({
    required this.corpusName,
    required this.deletedFileName,
    required this.documentDeleted,
    required this.message,
    required this.operationName,
    required this.status,
  });

  factory DeleteCorpusDocumentSerializer.fromJson(Map<String, dynamic> json) {
    return DeleteCorpusDocumentSerializer(
      corpusName: json['corpusName'],
      deletedFileName: json['deletedFileName'],
      documentDeleted: json['documentDeleted'],
      message: json['message'],
      operationName: json['operationName'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'corpusName': corpusName,
      'deletedFileName': deletedFileName,
      'documentDeleted': documentDeleted,
      'message': message,
      'operationName': operationName,
      'status': status,
    };
  }
}