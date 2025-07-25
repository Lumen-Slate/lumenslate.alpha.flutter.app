class ListCorpusContentSerializer {
  final String corpusName;
  final int databaseCount;
  final int ragEngineCount;
  final int totalDocuments;
  final String status;
  final List<RagFileItem> documents;

  ListCorpusContentSerializer({
    required this.corpusName,
    required this.databaseCount,
    required this.ragEngineCount,
    required this.totalDocuments,
    required this.status,
    required this.documents,
  });

  factory ListCorpusContentSerializer.fromJson(Map<String, dynamic> json) {
    return ListCorpusContentSerializer(
      corpusName: json['corpusName'],
      databaseCount: json['databaseCount'],
      ragEngineCount: json['ragEngineCount'],
      totalDocuments: json['totalDocuments'],
      status: json['status'],
      documents: (json['documents'] as List)
          .map((e) => RagFileItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'corpusName': corpusName,
      'databaseCount': databaseCount,
      'ragEngineCount': ragEngineCount,
      'totalDocuments': totalDocuments,
      'status': status,
      'documents': documents.map((e) => e.toJson()).toList(),
    };
  }
}

class RagFileItem {
  final String fileId;
  final String displayName;
  final String corpusName;
  final String createdAt;
  final String gcsObject;
  final bool inDatabase;
  final bool inRAGEngine;
  final RagEngineInfo? ragEngineInfo;
  final String ragFileId;

  RagFileItem({
    required this.fileId,
    required this.displayName,
    required this.corpusName,
    required this.createdAt,
    required this.gcsObject,
    required this.inDatabase,
    required this.inRAGEngine,
    required this.ragEngineInfo,
    required this.ragFileId,
  });

  factory RagFileItem.fromJson(Map<String, dynamic> json) {
    return RagFileItem(
      fileId: json['fileId'],
      displayName: json['displayName'],
      corpusName: json['corpusName'],
      createdAt: json['createdAt'],
      gcsObject: json['gcsObject'],
      inDatabase: json['inDatabase'],
      inRAGEngine: json['inRAGEngine'],
      ragEngineInfo: json['ragEngineInfo'] != null
          ? RagEngineInfo.fromJson(json['ragEngineInfo'])
          : null,
      ragFileId: json['ragFileId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileId': fileId,
      'displayName': displayName,
      'corpusName': corpusName,
      'createdAt': createdAt,
      'gcsObject': gcsObject,
      'inDatabase': inDatabase,
      'inRAGEngine': inRAGEngine,
      'ragEngineInfo': ragEngineInfo?.toJson(),
      'ragFileId': ragFileId,
    };
  }
}

class RagEngineInfo {
  final String createTime;
  final String displayName;
  final String id;
  final String updateTime;

  RagEngineInfo({
    required this.createTime,
    required this.displayName,
    required this.id,
    required this.updateTime,
  });

  factory RagEngineInfo.fromJson(Map<String, dynamic> json) {
    return RagEngineInfo(
      createTime: json['createTime'],
      displayName: json['displayName'],
      id: json['id'],
      updateTime: json['updateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createTime': createTime,
      'displayName': displayName,
      'id': id,
      'updateTime': updateTime,
    };
  }
}