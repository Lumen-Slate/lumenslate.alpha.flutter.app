import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:lumen_slate/lib.dart';
import '../../../services/pdf_generator_service.dart';

class PdfGeneratorPageMobile extends StatefulWidget {
  const PdfGeneratorPageMobile({super.key});

  @override
  State<PdfGeneratorPageMobile> createState() => _PdfGeneratorPageMobileState();
}

class _PdfGeneratorPageMobileState extends State<PdfGeneratorPageMobile> {
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
        behavior: SnackBarBehavior.floating,
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
        title: Text(
          'Delete PDF',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete ${file.path.split('/').last}?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'PDF Generator',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadSavedPDFs();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Generation Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Generate Question Paper',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Subject Selection
                    Text(
                      'Select Subject:',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.white,
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedSubject,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        items: _subjects.map((subject) {
                          return DropdownMenuItem(
                            value: subject,
                            child: Text(
                              subject,
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
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
                    ),
                    const SizedBox(height: 20),

                    // Generate Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
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
                            : const Icon(Icons.picture_as_pdf, size: 20),
                        label: Text(
                          _isGenerating ? 'Generating...' : 'Generate PDF',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Info about what will be generated
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.blue.shade600,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'What will be generated:',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _selectedSubject == 'Mixed'
                                ? '• Multiple Choice Questions (8)\n• Multiple Select Questions (4)\n• Numerical Answer Type (4)\n• Subjective Questions (3)\n• Professional formatting with instructions'
                                : '• Subject-specific questions\n• Multiple question types\n• Proper answer spaces\n• Professional formatting',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Saved PDFs Section
              if (!kIsWeb) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Saved Question Papers',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (_savedPDFs.isNotEmpty)
                      Text(
                        '${_savedPDFs.length} file${_savedPDFs.length != 1 ? 's' : ''}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                if (_savedPDFs.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No PDFs generated yet',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Generate your first question paper above',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
              ] else ...[
                // Web-specific info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 48,
                        color: Colors.blue.shade400,
                      ),
                      const SizedBox(height: 16),
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
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],

              // Mobile-optimized saved PDFs list
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

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red.shade600,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          fileName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Size: $formattedSize',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
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
                            PopupMenuItem(
                              value: 'copy_path',
                              child: Row(
                                children: [
                                  Icon(Icons.copy, size: 18, color: Colors.grey[700]),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Copy Path',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  const Icon(Icons.delete, size: 18, color: Colors.red),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Delete',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              
              // Bottom spacing for better scrolling experience
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
