import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html;
import '../constants/dummy_data/questions/mcq.dart';
import '../constants/dummy_data/questions/msq.dart';
import '../constants/dummy_data/questions/nat.dart';
import '../constants/dummy_data/questions/subjective.dart';
import '../models/questions/mcq.dart';
import '../models/questions/msq.dart';
import '../models/questions/nat.dart';
import '../models/questions/subjective.dart';

class PdfGeneratorService {
  static const String _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  // Generate a comprehensive question paper PDF
  static Future<File> generateQuestionPaper({
    String title = "Sample Question Paper",
    String subtitle = "Mixed Question Types",
    int mcqCount = 5,
    int msqCount = 3,
    int natCount = 3,
    int subjectiveCount = 2,
  }) async {
    final pdf = pw.Document();

    // Get sample questions
    final selectedMCQs = dummyMCQs.take(mcqCount).toList();
    final selectedMSQs = dummyMSQs.take(msqCount).toList();
    final selectedNATs = dummyNATs.take(natCount).toList();
    final selectedSubjectives = dummySubjectives.take(subjectiveCount).toList();

    // Calculate total points
    final totalPoints = selectedMCQs.fold<int>(0, (sum, q) => sum + q.points) +
        selectedMSQs.fold<int>(0, (sum, q) => sum + q.points) +
        selectedNATs.fold<int>(0, (sum, q) => sum + q.points) +
        selectedSubjectives.fold<int>(0, (sum, q) => sum + q.points);

    // Create PDF pages
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          List<pw.Widget> content = [];

          // Header
          content.add(_buildHeader(title, subtitle, totalPoints));
          content.add(pw.SizedBox(height: 20));

          // Instructions
          content.add(_buildInstructions());
          content.add(pw.SizedBox(height: 30));

          int questionNumber = 1;

          // MCQ Section
          if (selectedMCQs.isNotEmpty) {
            content.add(_buildSectionHeader("SECTION A: Multiple Choice Questions", 
                "Choose the correct option. Each question carries ${selectedMCQs.first.points} marks."));
            content.add(pw.SizedBox(height: 15));

            for (final mcq in selectedMCQs) {
              content.add(_buildMCQQuestion(questionNumber, mcq));
              content.add(pw.SizedBox(height: 15));
              questionNumber++;
            }
            content.add(pw.SizedBox(height: 20));
          }

          // MSQ Section
          if (selectedMSQs.isNotEmpty) {
            content.add(_buildSectionHeader("SECTION B: Multiple Select Questions", 
                "Select all correct options. Each question carries ${selectedMSQs.first.points} marks."));
            content.add(pw.SizedBox(height: 15));

            for (final msq in selectedMSQs) {
              content.add(_buildMSQQuestion(questionNumber, msq));
              content.add(pw.SizedBox(height: 15));
              questionNumber++;
            }
            content.add(pw.SizedBox(height: 20));
          }

          // NAT Section
          if (selectedNATs.isNotEmpty) {
            content.add(_buildSectionHeader("SECTION C: Numerical Answer Type", 
                "Enter the numerical value as your answer. Each question carries varying marks."));
            content.add(pw.SizedBox(height: 15));

            for (final nat in selectedNATs) {
              content.add(_buildNATQuestion(questionNumber, nat));
              content.add(pw.SizedBox(height: 15));
              questionNumber++;
            }
            content.add(pw.SizedBox(height: 20));
          }

          // Subjective Section
          if (selectedSubjectives.isNotEmpty) {
            content.add(_buildSectionHeader("SECTION D: Subjective Questions", 
                "Write detailed answers. Each question carries varying marks."));
            content.add(pw.SizedBox(height: 15));

            for (final subjective in selectedSubjectives) {
              content.add(_buildSubjectiveQuestion(questionNumber, subjective));
              content.add(pw.SizedBox(height: 20));
              questionNumber++;
            }
          }

          return content;
        },
      ),
    );

    // Save PDF to file
    return await _savePdfToFile(pdf, 'question_paper_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  // Generate specific subject question paper
  static Future<File> generateSubjectQuestionPaper(String subject) async {
    List<MCQ> subjectMCQs;
    List<MSQ> subjectMSQs;
    List<NAT> subjectNATs;
    List<Subjective> subjectSubjectives;

    // Filter questions by subject (using bankId as subject identifier)
    switch (subject.toLowerCase()) {
      case 'physics':
        subjectMCQs = dummyMCQs.where((q) => q.bankId == '201').toList();
        subjectMSQs = dummyMSQs.where((q) => q.bankId == '201').toList();
        subjectNATs = dummyNATs.where((q) => q.bankId == '201').toList();
        subjectSubjectives = dummySubjectives.where((q) => q.bankId == '201').toList();
        break;
      case 'chemistry':
        subjectMCQs = dummyMCQs.where((q) => q.bankId == '202').toList();
        subjectMSQs = dummyMSQs.where((q) => q.bankId == '202').toList();
        subjectNATs = dummyNATs.where((q) => q.bankId == '202').toList();
        subjectSubjectives = dummySubjectives.where((q) => q.bankId == '202').toList();
        break;
      case 'mathematics':
        subjectMCQs = dummyMCQs.where((q) => q.bankId == '203').toList();
        subjectMSQs = dummyMSQs.where((q) => q.bankId == '203').toList();
        subjectNATs = dummyNATs.where((q) => q.bankId == '203').toList();
        subjectSubjectives = dummySubjectives.where((q) => q.bankId == '203').toList();
        break;
      case 'biology':
        subjectMCQs = dummyMCQs.where((q) => q.bankId == '204').toList();
        subjectMSQs = dummyMSQs.where((q) => q.bankId == '204').toList();
        subjectNATs = dummyNATs.where((q) => q.bankId == '204').toList();
        subjectSubjectives = dummySubjectives.where((q) => q.bankId == '204').toList();
        break;
      case 'history':
        subjectMCQs = dummyMCQs.where((q) => q.bankId == '205').toList();
        subjectMSQs = dummyMSQs.where((q) => q.bankId == '205').toList();
        subjectNATs = dummyNATs.where((q) => q.bankId == '205').toList();
        subjectSubjectives = dummySubjectives.where((q) => q.bankId == '205').toList();
        break;
      default:
        subjectMCQs = dummyMCQs.take(3).toList();
        subjectMSQs = dummyMSQs.take(2).toList();
        subjectNATs = dummyNATs.take(2).toList();
        subjectSubjectives = dummySubjectives.take(1).toList();
    }

    final pdf = pw.Document();
    final totalPoints = subjectMCQs.fold<int>(0, (sum, q) => sum + q.points) +
        subjectMSQs.fold<int>(0, (sum, q) => sum + q.points) +
        subjectNATs.fold<int>(0, (sum, q) => sum + q.points) +
        subjectSubjectives.fold<int>(0, (sum, q) => sum + q.points);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          List<pw.Widget> content = [];

          // Header
          content.add(_buildHeader("${subject.toUpperCase()} Question Paper", 
              "Subject-specific examination", totalPoints));
          content.add(pw.SizedBox(height: 20));

          // Instructions
          content.add(_buildInstructions());
          content.add(pw.SizedBox(height: 30));

          int questionNumber = 1;

          // Add questions by type
          if (subjectMCQs.isNotEmpty) {
            content.add(_buildSectionHeader("SECTION A: Multiple Choice Questions", 
                "Choose the correct option."));
            content.add(pw.SizedBox(height: 15));

            for (final mcq in subjectMCQs) {
              content.add(_buildMCQQuestion(questionNumber, mcq));
              content.add(pw.SizedBox(height: 15));
              questionNumber++;
            }
            content.add(pw.SizedBox(height: 20));
          }

          if (subjectMSQs.isNotEmpty) {
            content.add(_buildSectionHeader("SECTION B: Multiple Select Questions", 
                "Select all correct options."));
            content.add(pw.SizedBox(height: 15));

            for (final msq in subjectMSQs) {
              content.add(_buildMSQQuestion(questionNumber, msq));
              content.add(pw.SizedBox(height: 15));
              questionNumber++;
            }
            content.add(pw.SizedBox(height: 20));
          }

          if (subjectNATs.isNotEmpty) {
            content.add(_buildSectionHeader("SECTION C: Numerical Answer Type", 
                "Enter the numerical value."));
            content.add(pw.SizedBox(height: 15));

            for (final nat in subjectNATs) {
              content.add(_buildNATQuestion(questionNumber, nat));
              content.add(pw.SizedBox(height: 15));
              questionNumber++;
            }
            content.add(pw.SizedBox(height: 20));
          }

          if (subjectSubjectives.isNotEmpty) {
            content.add(_buildSectionHeader("SECTION D: Subjective Questions", 
                "Write detailed answers."));
            content.add(pw.SizedBox(height: 15));

            for (final subjective in subjectSubjectives) {
              content.add(_buildSubjectiveQuestion(questionNumber, subjective));
              content.add(pw.SizedBox(height: 20));
              questionNumber++;
            }
          }

          return content;
        },
      ),
    );

    return await _savePdfToFile(pdf, '${subject.toLowerCase()}_question_paper_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  // Build PDF header
  static pw.Widget _buildHeader(String title, String subtitle, int totalPoints) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          "LUMEN SLATE",
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          subtitle,
          style: const pw.TextStyle(
            fontSize: 14,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("Date: _______________"),
            pw.Text("Total Marks: $totalPoints"),
            pw.Text("Time: 3 Hours"),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Text("Student Name: _________________________     Roll No: ___________"),
      ],
    );
  }

  // Build instructions section
  static pw.Widget _buildInstructions() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "INSTRUCTIONS:",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
          ),
          pw.SizedBox(height: 10),
          pw.Text("- Read all questions carefully before attempting."),
          pw.Text("- For MCQ questions, select only ONE correct option."),
          pw.Text("- For MSQ questions, select ALL correct options."),
          pw.Text("- For numerical questions, write only the numerical value."),
          pw.Text("- For subjective questions, write detailed explanations."),
          pw.Text("- Use of calculators is allowed where applicable."),
          pw.Text("- All questions are compulsory."),
        ],
      ),
    );
  }

  // Build section header
  static pw.Widget _buildSectionHeader(String title, String description) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            description,
            style: const pw.TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Build MCQ question
  static pw.Widget _buildMCQQuestion(int questionNumber, MCQ mcq) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "Q$questionNumber. ${mcq.question} [${mcq.points} marks]",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        ...mcq.options.asMap().entries.map(
          (entry) => pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20, bottom: 5),
            child: pw.Text("(${_alphabet[entry.key]}) ${entry.value}"),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
            borderRadius: pw.BorderRadius.circular(3),
          ),
          child: pw.Text("Answer: ___________"),
        ),
      ],
    );
  }

  // Build MSQ question
  static pw.Widget _buildMSQQuestion(int questionNumber, MSQ msq) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "Q$questionNumber. ${msq.question} [${msq.points} marks]",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        ...msq.options.asMap().entries.map(
          (entry) => pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20, bottom: 5),
            child: pw.Text("(${_alphabet[entry.key]}) ${entry.value}"),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
            borderRadius: pw.BorderRadius.circular(3),
          ),
          child: pw.Text("Selected Options: ___________"),
        ),
      ],
    );
  }

  // Build NAT question
  static pw.Widget _buildNATQuestion(int questionNumber, NAT nat) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "Q$questionNumber. ${nat.question} [${nat.points} marks]",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 15),
        pw.Container(
          width: 200,
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
            borderRadius: pw.BorderRadius.circular(3),
          ),
          child: pw.Text("Answer: ___________"),
        ),
      ],
    );
  }

  // Build Subjective question
  static pw.Widget _buildSubjectiveQuestion(int questionNumber, Subjective subjective) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "Q$questionNumber. ${subjective.question} [${subjective.points} marks]",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 15),
        pw.Container(
          width: double.infinity,
          height: 150,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
            borderRadius: pw.BorderRadius.circular(3),
          ),
          child: pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Answer:"),
                pw.SizedBox(height: 10),
                // Lines for writing
                ...List.generate(6, (index) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 15),
                  child: pw.Divider(),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Save PDF to file (Web and Mobile compatible)
  static Future<File> _savePdfToFile(pw.Document pdf, String fileName) async {
    final bytes = await pdf.save();
    
    if (kIsWeb) {
      // For web: trigger download
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = fileName;
      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
      
      // Return a dummy file for web
      return File(fileName);
    } else {
      // For mobile/desktop: save to documents directory
      final output = await getApplicationDocumentsDirectory();
      final file = File("${output.path}/$fileName");
      await file.writeAsBytes(bytes);
      return file;
    }
  }

  // Get all available PDF files (Mobile only)
  static Future<List<File>> getSavedPDFs() async {
    if (kIsWeb) {
      // Web doesn't support file listing
      return [];
    }
    
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync()
          .where((file) => file.path.endsWith('.pdf'))
          .map((file) => File(file.path))
          .toList();
      return files;
    } catch (e) {
      return [];
    }
  }

  // Delete a PDF file (Mobile only)
  static Future<bool> deletePDF(String filePath) async {
    if (kIsWeb) {
      // Web doesn't support file deletion
      return false;
    }
    
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
} 