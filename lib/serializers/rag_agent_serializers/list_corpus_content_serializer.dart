// lib/serializers/rag_agent_serializers/list_corpus_content_serializer.dart
class ListCorpusContentSerializer {
  final String corpusName;
  final String displayName;
  final List<RagFileItem> files;
  final int filesCount;
  final String message;
  final String status;

  ListCorpusContentSerializer({
    required this.corpusName,
    required this.displayName,
    required this.files,
    required this.filesCount,
    required this.message,
    required this.status,
  });

  factory ListCorpusContentSerializer.fromJson(Map<String, dynamic> json) {
    return ListCorpusContentSerializer(
      corpusName: json['corpusName'],
      displayName: json['displayName'],
      files: (json['files'] as List)
          .map((e) => RagFileItem.fromJson(e))
          .toList(),
      filesCount: json['filesCount'],
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'corpusName': corpusName,
      'displayName': displayName,
      'files': files.map((e) => e.toJson()).toList(),
      'filesCount': filesCount,
      'message': message,
      'status': status,
    };
  }
}

class RagFileItem {
  final String createTime;
  final String description;
  final String displayName;
  final String name;
  final String updateTime;

  RagFileItem({
    required this.createTime,
    required this.description,
    required this.displayName,
    required this.name,
    required this.updateTime,
  });

  factory RagFileItem.fromJson(Map<String, dynamic> json) {
    return RagFileItem(
      createTime: json['createTime'],
      description: json['description'],
      displayName: json['displayName'],
      name: json['name'],
      updateTime: json['updateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createTime': createTime,
      'description': description,
      'displayName': displayName,
      'name': name,
      'updateTime': updateTime,
    };
  }
}