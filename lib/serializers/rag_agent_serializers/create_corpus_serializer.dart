class CreateCorpusSerializer {
  final bool corpusCreated;
  final String corpusName;
  final String displayName;
  final String message;
  final String status;

  CreateCorpusSerializer({
    required this.corpusCreated,
    required this.corpusName,
    required this.displayName,
    required this.message,
    required this.status,
  });

  factory CreateCorpusSerializer.fromJson(Map<String, dynamic> json) {
    return CreateCorpusSerializer(
      corpusCreated: json['corpusCreated'],
      corpusName: json['corpusName'],
      displayName: json['displayName'],
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'corpusCreated': corpusCreated,
      'corpusName': corpusName,
      'displayName': displayName,
      'message': message,
      'status': status,
    };
  }
}