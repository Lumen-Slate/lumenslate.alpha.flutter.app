import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/questions/mcq.dart';
import '../models/questions/msq.dart';
import '../models/questions/nat.dart';
import '../models/questions/subjective.dart';

class QuestionApiService {
  static const String baseUrl = 'http://localhost:8080'; // Update with your server URL
  
  // MCQ operations
  static Future<MCQ> updateMCQ(MCQ mcq) async {
    final response = await http.put(
      Uri.parse('$baseUrl/mcqs/${mcq.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(mcq.toJson()),
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
  static Future<MSQ> updateMSQ(MSQ msq) async {
    final response = await http.put(
      Uri.parse('$baseUrl/msqs/${msq.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(msq.toJson()),
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
  static Future<NAT> updateNAT(NAT nat) async {
    final response = await http.put(
      Uri.parse('$baseUrl/nats/${nat.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nat.toJson()),
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
  static Future<Subjective> updateSubjective(Subjective subjective) async {
    final response = await http.put(
      Uri.parse('$baseUrl/subjectives/${subjective.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(subjective.toJson()),
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