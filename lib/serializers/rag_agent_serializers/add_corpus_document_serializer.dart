// lib/serializers/rag_agent_serializers/add_corpus_serializer.dart
class AddCorpusDocumentSerializer {
  final String corpusName;
  final String displayName;
  final String fileId;
  final String gcsObject;
  final String message;
  final String ragFileId;
  final int size;

  AddCorpusDocumentSerializer({
    required this.corpusName,
    required this.displayName,
    required this.fileId,
    required this.gcsObject,
    required this.message,
    required this.ragFileId,
    required this.size,
  });

  factory AddCorpusDocumentSerializer.fromJson(Map<String, dynamic> json) {
    return AddCorpusDocumentSerializer(
      corpusName: json['corpusName'],
      displayName: json['displayName'],
      fileId: json['fileId'],
      gcsObject: json['gcsObject'],
      message: json['message'],
      ragFileId: json['ragFileId'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'corpusName': corpusName,
      'displayName': displayName,
      'fileId': fileId,
      'gcsObject': gcsObject,
      'message': message,
      'ragFileId': ragFileId,
      'size': size,
    };
  }
}