// lib/serializers/rag_agent_serializers/list_corpora_serializer.dart
class ListCorporaSerializer {
  final List<RagCorpusItem> corpora;
  final int corporaCount;
  final String message;
  final String status;

  ListCorporaSerializer({
    required this.corpora,
    required this.corporaCount,
    required this.message,
    required this.status,
  });

  factory ListCorporaSerializer.fromJson(Map<String, dynamic> json) {
    return ListCorporaSerializer(
      corpora: (json['corpora'] as List)
          .map((e) => RagCorpusItem.fromJson(e))
          .toList(),
      corporaCount: json['corporaCount'],
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'corpora': corpora.map((e) => e.toJson()).toList(),
      'corporaCount': corporaCount,
      'message': message,
      'status': status,
    };
  }
}



class RagCorpusItem {
  final String createTime;
  final String displayName;
  final String name;
  final String updateTime;

  RagCorpusItem({
    required this.createTime,
    required this.displayName,
    required this.name,
    required this.updateTime,
  });

  factory RagCorpusItem.fromJson(Map<String, dynamic> json) {
    return RagCorpusItem(
      createTime: json['createTime'],
      displayName: json['displayName'],
      name: json['name'],
      updateTime: json['updateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createTime': createTime,
      'displayName': displayName,
      'name': name,
      'updateTime': updateTime,
    };
  }
}