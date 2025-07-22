class ListCorpusContentSerializer {
  final String corpusName;
  final int count;
  final List<RagFileItem> documents;

  ListCorpusContentSerializer({
    required this.corpusName,
    required this.count,
    required this.documents,
  });

  factory ListCorpusContentSerializer.fromJson(Map<String, dynamic> json) {
    return ListCorpusContentSerializer(
      corpusName: json['corpusName'],
      count: json['count'],
      documents: (json['documents'] as List)
          .map((e) => RagFileItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'corpusName': corpusName,
      'count': count,
      'documents': documents.map((e) => e.toJson()).toList(),
    };
  }
}

class RagFileItem {
  final String fileId;
  final String displayName;
  final String contentType;
  final int size;
  final String corpusName;
  final String createdAt;

  RagFileItem({
    required this.fileId,
    required this.displayName,
    required this.contentType,
    required this.size,
    required this.corpusName,
    required this.createdAt,
  });

  factory RagFileItem.fromJson(Map<String, dynamic> json) {
    return RagFileItem(
      fileId: json['fileId'],
      displayName: json['displayName'],
      contentType: json['contentType'],
      size: json['size'],
      corpusName: json['corpusName'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileId': fileId,
      'displayName': displayName,
      'contentType': contentType,
      'size': size,
      'corpusName': corpusName,
      'createdAt': createdAt,
    };
  }
}