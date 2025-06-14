import 'package:uuid/uuid.dart';
import '../../models/questions/mcq.dart';
import '../../models/questions/msq.dart';
import '../../models/questions/nat.dart';
import '../../models/questions/subjective.dart';

class RagGeneratedQuestionsSerializer {
  final String corpusUsed;
  final List<MCQ> mcqs;
  final List<MSQ> msqs;
  final List<NAT> nats;
  final List<Subjective> subjectives;
  final int totalQuestionsGenerated;

  RagGeneratedQuestionsSerializer({
    required this.corpusUsed,
    required this.mcqs,
    required this.msqs,
    required this.nats,
    required this.subjectives,
    required this.totalQuestionsGenerated,
  });

  factory RagGeneratedQuestionsSerializer.fromJson(Map<String, dynamic> json) {
    String bankId = 'd624d970-2bbf-41cc-9ddc-f95358f74cbf';
    return RagGeneratedQuestionsSerializer(
      corpusUsed: json['corpusUsed'] ?? '',
      mcqs:
          (json['mcqs'] as List<dynamic>?)
              ?.map(
                (e) => MCQ.fromJson({
                  ...e as Map<String, dynamic>,
                  "id": Uuid().v4(),
                  "bankId": bankId,
                  "variableIds": [],
                }),
              )
              .toList() ??
          [],
      msqs:
          (json['msqs'] as List<dynamic>?)
              ?.map(
                (e) => MSQ.fromJson({
                  ...e as Map<String, dynamic>,
                  "id": Uuid().v4(),
                  "bankId": bankId,
                  "variableIds": [],
                }),
              )
              .toList() ??
          [],
      nats:
          (json['nats'] as List<dynamic>?)
              ?.map(
                (e) => NAT.fromJson({
                  ...e as Map<String, dynamic>,
                  "id": Uuid().v4(),
                  "bankId": bankId,
                  "variableIds": [],
                }),
              )
              .toList() ??
          [],
      subjectives:
          (json['subjectives'] as List<dynamic>?)
              ?.map(
                (e) => Subjective.fromJson({
                  ...e as Map<String, dynamic>,
                  "id": Uuid().v4(),
                  "bankId": bankId,
                  "variableIds": [],
                }),
              )
              .toList() ??
          [],
      totalQuestionsGenerated: json['totalQuestionsGenerated'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'corpusUsed': corpusUsed,
      'mcqs': mcqs.map((e) => e.toJson()).toList(),
      'msqs': msqs.map((e) => e.toJson()).toList(),
      'nats': nats.map((e) => e.toJson()).toList(),
      'subjectives': subjectives.map((e) => e.toJson()).toList(),
      'totalQuestionsGenerated': totalQuestionsGenerated,
    };
  }
}
