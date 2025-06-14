import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/questions/mcq.dart';
import '../models/questions/msq.dart';
import '../models/questions/nat.dart';
import '../models/questions/subjective.dart';

class QuestionApiService {
  static const String baseUrl = 'http://localhost:8080'; // Update with your server URL
  
  // Helper function to compare lists
  static bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
  
  // MCQ operations
  static Future<MCQ> updateMCQ(MCQ original, MCQ updated) async {
    // Build PATCH payload with only changed fields
    final Map<String, dynamic> changes = {};
    
    if (original.question != updated.question) changes['question'] = updated.question;
    if (original.points != updated.points) changes['points'] = updated.points;
    if (!_listEquals(original.options, updated.options)) changes['options'] = updated.options;
    if (original.answerIndex != updated.answerIndex) changes['answerIndex'] = updated.answerIndex;
    if (original.bankId != updated.bankId) changes['bankId'] = updated.bankId;
    if (!_listEquals(original.variableIds, updated.variableIds)) changes['variableIds'] = updated.variableIds;
    
    if (changes.isEmpty) {
      return updated; // No changes to apply
    }
    
    final response = await http.patch(
      Uri.parse('$baseUrl/mcqs/${updated.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(changes),
    );

    if (response.statusCode == 200) {
      return MCQ.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update MCQ: ${response.body}');
    }
  }

  static Future<void> deleteMCQ(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/mcqs/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete MCQ: ${response.body}');
    }
  }

  // MSQ operations
  static Future<MSQ> updateMSQ(MSQ original, MSQ updated) async {
    // Build PATCH payload with only changed fields
    final Map<String, dynamic> changes = {};
    
    if (original.question != updated.question) changes['question'] = updated.question;
    if (original.points != updated.points) changes['points'] = updated.points;
    if (!_listEquals(original.options, updated.options)) changes['options'] = updated.options;
    if (!_listEquals(original.answerIndices, updated.answerIndices)) changes['answerIndices'] = updated.answerIndices;
    if (original.bankId != updated.bankId) changes['bankId'] = updated.bankId;
    if (!_listEquals(original.variableIds, updated.variableIds)) changes['variableIds'] = updated.variableIds;
    
    if (changes.isEmpty) {
      return updated; // No changes to apply
    }
    
    final response = await http.patch(
      Uri.parse('$baseUrl/msqs/${updated.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(changes),
    );

    if (response.statusCode == 200) {
      return MSQ.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update MSQ: ${response.body}');
    }
  }

  static Future<void> deleteMSQ(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/msqs/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete MSQ: ${response.body}');
    }
  }

  // NAT operations
  static Future<NAT> updateNAT(NAT original, NAT updated) async {
    // Build PATCH payload with only changed fields
    final Map<String, dynamic> changes = {};
    
    if (original.question != updated.question) changes['question'] = updated.question;
    if (original.points != updated.points) changes['points'] = updated.points;
    if (original.answer != updated.answer) changes['answer'] = updated.answer;
    if (original.bankId != updated.bankId) changes['bankId'] = updated.bankId;
    if (!_listEquals(original.variableIds, updated.variableIds)) changes['variableIds'] = updated.variableIds;
    
    if (changes.isEmpty) {
      return updated; // No changes to apply
    }
    
    final response = await http.patch(
      Uri.parse('$baseUrl/nats/${updated.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(changes),
    );

    if (response.statusCode == 200) {
      return NAT.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update NAT: ${response.body}');
    }
  }

  static Future<void> deleteNAT(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/nats/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete NAT: ${response.body}');
    }
  }

  // Subjective operations
  static Future<Subjective> updateSubjective(Subjective original, Subjective updated) async {
    // Build PATCH payload with only changed fields
    final Map<String, dynamic> changes = {};
    
    if (original.question != updated.question) changes['question'] = updated.question;
    if (original.points != updated.points) changes['points'] = updated.points;
    if (original.idealAnswer != updated.idealAnswer) changes['idealAnswer'] = updated.idealAnswer;
    if (!_listEquals(original.gradingCriteria, updated.gradingCriteria)) changes['gradingCriteria'] = updated.gradingCriteria;
    if (original.bankId != updated.bankId) changes['bankId'] = updated.bankId;
    if (!_listEquals(original.variableIds, updated.variableIds)) changes['variableIds'] = updated.variableIds;
    
    if (changes.isEmpty) {
      return updated; // No changes to apply
    }
    
    final response = await http.patch(
      Uri.parse('$baseUrl/subjectives/${updated.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(changes),
    );

    if (response.statusCode == 200) {
      return Subjective.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update Subjective: ${response.body}');
    }
  }

  static Future<void> deleteSubjective(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/subjectives/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete Subjective: ${response.body}');
    }
  }
} 