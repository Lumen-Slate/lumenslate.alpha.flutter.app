import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:lumen_slate/lib.dart';
import '../services/pdf_generator_service.dart';

class PdfGeneratorPage extends StatefulWidget {
  const PdfGeneratorPage({super.key});

  @override
  State<PdfGeneratorPage> createState() => _PdfGeneratorPageState();
}

class _PdfGeneratorPageState extends State<PdfGeneratorPage> {
  bool _isGenerating = false;
  List<File> _savedPDFs = [];
  String _selectedSubject = 'Mixed';
  
  final List<String> _subjects = [
    'Mixed',
    'Physics',
    'Chemistry', 
    'Mathematics',
    'Biology',
    'History'
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedPDFs();
  }

  Future<void> _loadSavedPDFs() async {
    try {
      final pdfs = await PdfGeneratorService.getSavedPDFs();
      setState(() {
        _savedPDFs = pdfs;
      });
    } catch (e) {
      _showMessage('Error loading PDFs: $e', isError: true);
    }
  }

  Future<void> _generatePDF() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      File pdfFile;
      
      if (_selectedSubject == 'Mixed') {
        pdfFile = await PdfGeneratorService.generateQuestionPaper(
          title: 'Comprehensive Question Paper',
          subtitle: 'Mixed Subject Examination',
          mcqCount: 8,
          msqCount: 4,
          natCount: 4,
          subjectiveCount: 3,
        );
      } else {
        pdfFile = await PdfGeneratorService.generateSubjectQuestionPaper(_selectedSubject);
      }

      await _loadSavedPDFs();
      if (kIsWeb) {
        _showMessage(
          'PDF generated successfully!\nDownload should start automatically.',
          isError: false,
        );
      } else {
        _showMessage(
          'PDF generated successfully!\nSaved to: ${pdfFile.path}',
          isError: false,
        );
      }
    } catch (e) {
      _showMessage('Error generating PDF: $e', isError: true);
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  Future<void> _deletePDF(File file) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete PDF'),
        content: Text('Are you sure you want to delete ${file.path.split('/').last}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await PdfGeneratorService.deletePDF(file.path);
      if (success) {
        await _loadSavedPDFs();
        _showMessage('PDF deleted successfully', isError: false);
      } else {
        _showMessage('Error deleting PDF', isError: true);
      }
    }
  }

  void _copyPath(String path) {
    Clipboard.setData(ClipboardData(text: path));
    _showMessage('Path copied to clipboard', isError: false);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: AppConstants.desktopScaleWidth,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'PDF Question Paper Generator',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.blue.shade50,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Generation Section
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Generate Question Paper',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Subject Selection
                      Text(
                        'Select Subject:',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedSubject,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: _subjects.map((subject) {
                          return DropdownMenuItem(
                            value: subject,
                            child: Text(subject),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedSubject = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // Generate Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isGenerating ? null : _generatePDF,
                          icon: _isGenerating
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.picture_as_pdf),
                          label: Text(
                            _isGenerating ? 'Generating...' : 'Generate PDF',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Info about what will be generated
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'What will be generated:',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedSubject == 'Mixed'
                                  ? '- Multiple Choice Questions (8)\n- Multiple Select Questions (4)\n- Numerical Answer Type (4)\n- Subjective Questions (3)\n- Professional formatting with instructions'
                                  : '- Subject-specific questions\n- Multiple question types\n- Proper answer spaces\n- Professional formatting',
                              style: GoogleFonts.poppins(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Saved PDFs Section (Mobile only)
              if (!kIsWeb) ...[
                Text(
                  'Saved Question Papers',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                if (_savedPDFs.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.folder_open,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No PDFs generated yet',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Generate your first question paper above',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ] else ...[
                // Web-specific info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 48,
                          color: Colors.blue.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Web Version Info',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'PDFs will be automatically downloaded to your default downloads folder when generated.',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // Mobile-only saved PDFs list
              if (!kIsWeb && _savedPDFs.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _savedPDFs.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final file = _savedPDFs[index];
                    final fileName = file.path.split('/').last;
                    final fileSize = file.lengthSync();
                    final formattedSize = '${(fileSize / 1024).toStringAsFixed(1)} KB';

                    return Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red,
                          size: 32,
                        ),
                        title: Text(
                          fileName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          'Size: $formattedSize',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            switch (value) {
                              case 'copy_path':
                                _copyPath(file.path);
                                break;
                              case 'delete':
                                _deletePDF(file);
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'copy_path',
                              child: ListTile(
                                leading: Icon(Icons.copy),
                                title: Text('Copy Path'),
                                dense: true,
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete, color: Colors.red),
                                title: Text('Delete'),
                                dense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
} 