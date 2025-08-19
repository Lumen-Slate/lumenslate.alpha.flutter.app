// lib/serializers/rag_agent_serializers/add_corpus_serializer.dart
class AddCorpusDocumentSerializer {
  final String fileId;
  final String status;
  final String message;
  final String responseTime;

  AddCorpusDocumentSerializer({
    required this.fileId,
    required this.status,
    required this.message,
    required this.responseTime,
  });

  factory AddCorpusDocumentSerializer.fromJson(Map<String, dynamic> json) {
    return AddCorpusDocumentSerializer(
      fileId: json['fileId'],
      status: json['status'],
      message: json['message'],
      responseTime: json['responseTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileId': fileId,
      'status': status,
      'message': message,
      'responseTime': responseTime,
    };
  }
}
