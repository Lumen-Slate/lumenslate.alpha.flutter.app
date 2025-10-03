import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:lumen_slate/models/extended/assignment_extended.dart';
import 'package:lumen_slate/services/firebase_monitoring_service.dart';
import 'package:lumen_slate/services/logging_service.dart';
import 'package:lumen_slate/services/notification_service.dart';
import 'package:lumen_slate/services/permission_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

import '../models/questions/mcq.dart';
import '../models/questions/msq.dart';
import '../models/questions/nat.dart';
import '../models/questions/subjective.dart';

class AssignmentExportService {
  static const String _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// Export assignment questions to PDF
  static Future<File> exportAssignmentPDF(AssignmentExtended assignment) async {
    return await FirebaseMonitoringService.measurePerformance(
      'assignment_pdf_export',
      () async {
        try {
          // Get questions for this assignment
          final mcqs = assignment.mcqs ?? [];
          final msqs = assignment.msqs ?? [];
          final nats = assignment.nats ?? [];
          final subjectives = assignment.subjectives ?? [];

          // Calculate total points
          final totalPoints =
              mcqs.fold<int>(0, (sum, q) => sum + q.points) +
              msqs.fold<int>(0, (sum, q) => sum + q.points) +
              nats.fold<int>(0, (sum, q) => sum + q.points) +
              subjectives.fold<int>(0, (sum, q) => sum + q.points);

          final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          buildBackground: (pw.Context context) => pw.Center(
            child: pw.Opacity(
              opacity: 0.20,
              child: pw.Transform.rotate(
                angle: -0.7, // ~-40 degrees, diagonal
                child: pw.Text(
                  'LUMEN SLATE',
                  textAlign: pw.TextAlign.center,
                  maxLines: 1,
                  softWrap: false,
                  style: pw.TextStyle(
                    fontSize: 80,
                    color: PdfColors.grey600,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        build: (pw.Context context) {
          List<pw.Widget> content = [];

          // Header
          content.add(_buildAssignmentHeader(assignment, totalPoints));
          content.add(pw.SizedBox(height: 20));

          // Instructions
          content.add(_buildInstructions());
          content.add(pw.SizedBox(height: 30));

          int questionNumber = 1;

          // MCQ Section
          if (mcqs.isNotEmpty) {
            content.add(
              _buildSectionHeader(
                "SECTION A: Multiple Choice Questions",
                "Choose the correct option. Each question carries varying marks.",
              ),
            );
            content.add(pw.SizedBox(height: 15));

            for (final mcq in mcqs) {
              content.add(_buildMCQQuestion(questionNumber, mcq));
              content.add(pw.SizedBox(height: 15));
              questionNumber++;
            }
            content.add(pw.SizedBox(height: 20));
          }

          // MSQ Section
          if (msqs.isNotEmpty) {
            content.add(
              _buildSectionHeader(
                "SECTION B: Multiple Select Questions",
                "Select all correct options. Each question carries varying marks.",
              ),
            );
            content.add(pw.SizedBox(height: 15));

            for (final msq in msqs) {
              content.add(_buildMSQQuestion(questionNumber, msq));
              content.add(pw.SizedBox(height: 15));
              questionNumber++;
            }
            content.add(pw.SizedBox(height: 20));
          }

          // NAT Section
          if (nats.isNotEmpty) {
            content.add(
              _buildSectionHeader(
                "SECTION C: Numerical Answer Type",
                "Enter the numerical value as your answer. Each question carries varying marks.",
              ),
            );
            content.add(pw.SizedBox(height: 15));

            for (final nat in nats) {
              content.add(_buildNATQuestion(questionNumber, nat));
              content.add(pw.SizedBox(height: 15));
              questionNumber++;
            }
            content.add(pw.SizedBox(height: 20));
          }

          // Subjective Section
          if (subjectives.isNotEmpty) {
            content.add(
              _buildSectionHeader(
                "SECTION D: Subjective Questions",
                "Write detailed answers. Each question carries varying marks.",
              ),
            );
            content.add(pw.SizedBox(height: 15));

            for (final subjective in subjectives) {
              content.add(_buildSubjectiveQuestion(questionNumber, subjective));
              content.add(pw.SizedBox(height: 20));
              questionNumber++;
            }
          }

          // Comments Section (if any)
          // if (assignment.commentIds.isNotEmpty) {
          //   content.add(pw.SizedBox(height: 30));
          //   content.add(_buildCommentsSection(assignment));
          // }

          // Just return the content list, no Stack needed
          return content;
        },
      ),
    );

    // Save PDF to file
    final fileName =
        '${assignment.title.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = await _savePdfToFile(pdf, fileName);
    
    // Log successful PDF export
    await FirebaseMonitoringService.logExportEvent(
      'PDF',
      fileName: fileName,
      success: true,
    );
    
    return file;
  } catch (error, stackTrace) {
    // Log failed PDF export
    await FirebaseMonitoringService.recordError(
      error,
      stackTrace,
      reason: 'PDF export failed for assignment: ${assignment.title}',
    );
    
    await FirebaseMonitoringService.logExportEvent(
      'PDF',
      fileName: assignment.title,
      success: false,
    );
    
    rethrow;
  }
},
attributes: {
  'assignment_id': assignment.id,
  'assignment_title': assignment.title,
  'total_questions': (
    (assignment.mcqs?.length ?? 0) +
    (assignment.msqs?.length ?? 0) +
    (assignment.nats?.length ?? 0) +
    (assignment.subjectives?.length ?? 0)
  ).toString(),
},
);
  }

  /// Build assignment header
  static pw.Widget _buildAssignmentHeader(
    AssignmentExtended assignment,
    int totalPoints,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          assignment.title.toUpperCase(),
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Text(assignment.body, style: const pw.TextStyle(fontSize: 14)),
        pw.SizedBox(height: 12),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "Due Date: ${assignment.dueDate.toLocal().toString().split(' ')[0]}",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              "Total Points: $totalPoints",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        pw.Divider(thickness: 2),
      ],
    );
  }

  /// Build general instructions
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
          pw.SizedBox(height: 8),
          pw.Text("1. Read all questions carefully before answering"),
          pw.Text("2. Answer all questions to the best of your ability"),
          pw.Text("3. For MCQs and MSQs, mark your answers clearly"),
          pw.Text("4. For numerical questions, provide exact values"),
          pw.Text("5. Write legibly for subjective questions"),
          pw.Text("6. Manage your time effectively"),
        ],
      ),
    );
  }

  /// Build section header
  static pw.Widget _buildSectionHeader(String title, String description) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey300,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
          ),
          pw.SizedBox(height: 4),
          pw.Text(description, style: const pw.TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  /// Build MCQ question
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

  /// Build MSQ question
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

  /// Build NAT question
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

  /// Build Subjective question
  static pw.Widget _buildSubjectiveQuestion(
    int questionNumber,
    Subjective subjective,
  ) {
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
                ...List.generate(
                  6,
                  (index) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 15),
                    child: pw.Divider(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build comments section
  // static pw.Widget _buildCommentsSection(Assignment assignment) {
  //   final comments = dummyComments
  //       .where((c) => assignment.commentIds.contains(c.id))
  //       .toList();
  //
  //   if (comments.isEmpty) return pw.SizedBox();
  //
  //   return pw.Column(
  //     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //     children: [
  //       pw.Text(
  //         "COMMENTS & FEEDBACK:",
  //         style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
  //       ),
  //       pw.SizedBox(height: 10),
  //       ...comments.map((comment) => pw.Container(
  //         margin: const pw.EdgeInsets.only(bottom: 8),
  //         padding: const pw.EdgeInsets.all(10),
  //         decoration: pw.BoxDecoration(
  //           color: PdfColors.grey100,
  //           border: pw.Border.all(color: PdfColors.grey300),
  //           borderRadius: pw.BorderRadius.circular(5),
  //         ),
  //         child: pw.Text(comment.commentBody),
  //       )),
  //     ],
  //   );
  // }

  /// Save PDF to file
  static Future<File> _savePdfToFile(pw.Document pdf, String fileName) async {
    final bytes = await pdf.save();

    if (kIsWeb) {
      // For web platform
      final blob = html.Blob([bytes], 'application/pdf');
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
      // For mobile/desktop platforms
      if (Platform.isAndroid) {
        // Request storage permission using PermissionService
        if (await PermissionService.requestStoragePermission()) {
          // Try to save to the public Downloads directory
          Directory? directory;

          try {
            // For Android, try to get the Downloads directory
            final externalDir = await getExternalStorageDirectory();
            if (externalDir != null) {
              // This gets us to /storage/emulated/0/Android/data/com.example.app/files
              // We want /storage/emulated/0/Download
              final publicDownloads = Directory('/storage/emulated/0/Download');
              if (await publicDownloads.exists()) {
                directory = publicDownloads;
              } else {
                // Fallback to /storage/emulated/0/Downloads (some devices use this)
                final alternativeDownloads = Directory(
                  '/storage/emulated/0/Downloads',
                );
                if (await alternativeDownloads.exists()) {
                  directory = alternativeDownloads;
                } else {
                  // Final fallback to external storage directory
                  directory = externalDir;
                }
              }
            }
          } catch (e) {
            // If all else fails, use getExternalStorageDirectory
            directory = await getExternalStorageDirectory();
          }

          if (directory == null) {
            throw Exception('Unable to access storage directory');
          }

          final file = File('${directory.path}/$fileName');
          await file.writeAsBytes(bytes);

          // Show download notification
          await NotificationService.showDownloadNotification(
            fileName: fileName,
            filePath: file.path,
          );

          // Try to make the file visible to media scanner
          try {
            if (Platform.isAndroid) {
              // This will make the file visible in file managers
              await Process.run('am', [
                'broadcast',
                '-a',
                'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
                '-d',
                'file://${file.path}',
              ]);
            }
          } catch (e) {
            // Media scanner broadcast failed, but file is still saved
            if (kDebugMode) {
              print('Media scanner notification failed: $e');
            }
          }

          return file;
        } else {
          throw Exception('Storage permission denied');
        }
      } else {
        // For iOS and other platforms
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(bytes);
        
        // Show download notification
        await NotificationService.showDownloadNotification(
          fileName: fileName,
          filePath: file.path,
        );
        
        return file;
      }
    }
  }

  /// Export assignment to CSV format
  static Future<File> exportAssignmentCSV(AssignmentExtended assignment) async {
    return await FirebaseMonitoringService.measurePerformance(
      'assignment_csv_export',
      () async {
        try {
          // Get questions for this assignment
          final mcqs = assignment.mcqs ?? [];
          final msqs = assignment.msqs ?? [];
          final nats = assignment.nats ?? [];
          final subjectives = assignment.subjectives ?? [];

    final StringBuffer csvContent = StringBuffer();

    // CSV Headers
    csvContent.writeln('Assignment Title,${assignment.title}');
    csvContent.writeln('Assignment Description,${assignment.body}');
    csvContent.writeln(
      'Due Date,${assignment.dueDate.toLocal().toString().split(' ')[0]}',
    );
    csvContent.writeln('Total Points,${assignment.points}');
    csvContent.writeln('');
    csvContent.writeln(
      'Question Type,Question Number,Question,Options,Points,Answer',
    );

    int questionNumber = 1;

    // Add MCQs
    for (final mcq in mcqs) {
      final options = mcq.options.join('; ');
      final correctAnswer = mcq.options[mcq.answerIndex];
      csvContent.writeln(
        'MCQ,$questionNumber,"${mcq.question}","$options",${mcq.points},"$correctAnswer"',
      );
      questionNumber++;
    }

    // Add MSQs
    for (final msq in msqs) {
      final options = msq.options.join('; ');
      final correctAnswers = msq.answerIndices
          .map((i) => msq.options[i])
          .join('; ');
      csvContent.writeln(
        'MSQ,$questionNumber,"${msq.question}","$options",${msq.points},"$correctAnswers"',
      );
      questionNumber++;
    }

    // Add NATs
    for (final nat in nats) {
      csvContent.writeln(
        'NAT,$questionNumber,"${nat.question}","N/A",${nat.points},${nat.answer}',
      );
      questionNumber++;
    }

    // Add Subjectives
    for (final subjective in subjectives) {
      csvContent.writeln(
        'Subjective,$questionNumber,"${subjective.question}","N/A",${subjective.points},"${subjective.idealAnswer}"',
      );
      questionNumber++;
    }

    // Save CSV to file
    final fileName =
        '${assignment.title.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.csv';

    final file = await _saveCsvToFile(csvContent.toString(), fileName);
    
    // Log successful CSV export
    await FirebaseMonitoringService.logExportEvent(
      'CSV',
      fileName: fileName,
      success: true,
    );
    
    return file;
  } catch (error, stackTrace) {
    // Log failed CSV export
    await FirebaseMonitoringService.recordError(
      error,
      stackTrace,
      reason: 'CSV export failed for assignment: ${assignment.title}',
    );
    
    await FirebaseMonitoringService.logExportEvent(
      'CSV',
      fileName: assignment.title,
      success: false,
    );
    
    rethrow;
  }
},
attributes: {
  'assignment_id': assignment.id,
  'assignment_title': assignment.title,
  'total_questions': (
    (assignment.mcqs?.length ?? 0) +
    (assignment.msqs?.length ?? 0) +
    (assignment.nats?.length ?? 0) +
    (assignment.subjectives?.length ?? 0)
  ).toString(),
},
);
  }

  /// Save CSV to file
  static Future<File> _saveCsvToFile(String content, String fileName) async {
    if (kIsWeb) {
      // For web platform
      final blob = html.Blob([content], 'text/csv');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = fileName;
      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);

      return File(fileName);
    } else {
      // For mobile/desktop platforms
      if (Platform.isAndroid) {
        // Request storage permission using PermissionService
        if (await PermissionService.requestStoragePermission()) {
          // Try to save to the public Downloads directory
          Directory? directory;

          try {
            // For Android, try to get the Downloads directory
            final externalDir = await getExternalStorageDirectory();
            if (externalDir != null) {
              // This gets us to /storage/emulated/0/Android/data/com.example.app/files
              // We want /storage/emulated/0/Download
              final publicDownloads = Directory('/storage/emulated/0/Download');
              if (await publicDownloads.exists()) {
                directory = publicDownloads;
              } else {
                // Fallback to /storage/emulated/0/Downloads (some devices use this)
                final alternativeDownloads = Directory(
                  '/storage/emulated/0/Downloads',
                );
                if (await alternativeDownloads.exists()) {
                  directory = alternativeDownloads;
                } else {
                  // Final fallback to external storage directory
                  directory = externalDir;
                }
              }
            }
          } catch (e) {
            // If all else fails, use getExternalStorageDirectory
            directory = await getExternalStorageDirectory();
          }

          if (directory == null) {
            throw Exception('Unable to access storage directory');
          }

          final file = File('${directory.path}/$fileName');
          await file.writeAsString(content);

          // Show download notification
          await NotificationService.showDownloadNotification(
            fileName: fileName,
            filePath: file.path,
          );

          // Try to make the file visible to media scanner
          try {
            if (Platform.isAndroid) {
              // This will make the file visible in file managers
              await Process.run('am', [
                'broadcast',
                '-a',
                'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
                '-d',
                'file://${file.path}',
              ]);
            }
          } catch (e) {
            // Media scanner broadcast failed, but file is still saved
            if (kDebugMode) {
              print('Media scanner notification failed: $e');
            }
          }

          return file;
        } else {
          throw Exception('Storage permission denied');
        }
      } else {
        // For iOS and other platforms
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsString(content);
        
        // Show download notification
        await NotificationService.showDownloadNotification(
          fileName: fileName,
          filePath: file.path,
        );
        
        return file;
      }
    }
  }
}
