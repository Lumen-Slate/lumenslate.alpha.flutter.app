// lib/serializers/rag_agent_serializers/add_corpus_serializer.dart
class AddCorpusDocumentSerializer {
  final String corpusName;
  final bool documentAdded;
  final String fileDisplayName;
  final String message;
  final String operationName;
  final String sourceUrl;
  final String status;

  AddCorpusDocumentSerializer({
    required this.corpusName,
    required this.documentAdded,
    required this.fileDisplayName,
    required this.message,
    required this.operationName,
    required this.sourceUrl,
    required this.status,
  });

  factory AddCorpusDocumentSerializer.fromJson(Map<String, dynamic> json) {
    return AddCorpusDocumentSerializer(
      corpusName: json['corpusName'],
      documentAdded: json['documentAdded'],
      fileDisplayName: json['fileDisplayName'],
      message: json['message'],
      operationName: json['operationName'],
      sourceUrl: json['sourceUrl'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'corpusName': corpusName,
      'documentAdded': documentAdded,
      'fileDisplayName': fileDisplayName,
      'message': message,
      'operationName': operationName,
      'sourceUrl': sourceUrl,
      'status': status,
    };
  }
}