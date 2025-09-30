import 'dart:async';
import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lumen_slate/lib.dart';
import 'package:lumen_slate/models/extended/assignment_extended.dart';

import '../../../blocs/assignment/assignment_bloc.dart';
import '../../../services/assignment_export_service.dart';

class AssignmentDetailPageMobile extends StatefulWidget {
  final String assignmentId;

  const AssignmentDetailPageMobile({super.key, required this.assignmentId});

  @override
  State<AssignmentDetailPageMobile> createState() =>
      _AssignmentDetailPageMobileState();
}

class _AssignmentDetailPageMobileState
    extends State<AssignmentDetailPageMobile> {
  final String _teacherId = '0692d515-1621-44ea-85e7-a41335858ee2';

  @override
  void initState() {
    context.read<AssignmentBloc>().add(
      FetchAssignmentById(id: widget.assignmentId, extended: true),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (result, _) {
        if (result) {
          context.read<AssignmentBloc>().add(
            InitializeAssignmentPaging(extended: false, teacherId: _teacherId),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            'Assignment Details',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'export') {
                  final state = context.read<AssignmentBloc>().state;
                  if (state is AssignmentSingleExtendedSuccess) {
                    _exportAssignment(context, state.assignment);
                  }
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'export',
                  child: Row(
                    children: [
                      const Icon(Icons.file_download, size: 20),
                      const SizedBox(width: 8),
                      Text('Export', style: GoogleFonts.poppins()),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: BlocBuilder<AssignmentBloc, AssignmentState>(
          builder: (context, state) {
            if (state is AssignmentSingleExtendedSuccess) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Assignment Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.assignment.title,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.assignment.body,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 16,
                                  color: Colors.red[600],
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Due: ${DateFormat('dd-MM-yyyy').format(state.assignment.dueDate)}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.red[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Questions Sections
                    if (state.assignment.mcqs != null &&
                        state.assignment.mcqs!.isNotEmpty)
                      _buildQuestionSection(
                        title: "Multiple Choice Questions",
                        description: "Choose the correct option",
                        backgroundColor: Colors.blue,
                        children: state.assignment.mcqs!
                            .map((q) => _buildMobileMCQTile(q))
                            .toList(),
                      ),
                    if (state.assignment.msqs != null &&
                        state.assignment.msqs!.isNotEmpty)
                      _buildQuestionSection(
                        title: "Multiple Select Questions",
                        description: "Select all correct options",
                        backgroundColor: Colors.green,
                        children: state.assignment.msqs!
                            .map((q) => _buildMobileMSQTile(q))
                            .toList(),
                      ),
                    if (state.assignment.nats != null &&
                        state.assignment.nats!.isNotEmpty)
                      _buildQuestionSection(
                        title: "Numerical Answer Type",
                        description: "Type the numerical answer",
                        backgroundColor: Colors.orange,
                        children: state.assignment.nats!
                            .map((q) => _buildMobileNATTile(q))
                            .toList(),
                      ),
                    if (state.assignment.subjectives != null &&
                        state.assignment.subjectives!.isNotEmpty)
                      _buildQuestionSection(
                        title: "Subjective Questions",
                        description: "Write descriptive answers",
                        backgroundColor: Colors.purple,
                        children: state.assignment.subjectives!
                            .map((q) => _buildMobileSubjectiveTile(q))
                            .toList(),
                      ),

                    // Comments Section
                    if (state.assignment.comments != null &&
                        state.assignment.comments!.isNotEmpty)
                      _buildQuestionSection(
                        title: "Comments",
                        description: "Remarks and feedback",
                        backgroundColor: Colors.grey,
                        children: state.assignment.comments!.map((comment) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.grey[400],
                                  child: const Icon(
                                    Icons.person,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    comment.commentBody,
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              );
            } else if (state is AssignmentSingleFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load assignment',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.red[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.error.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AssignmentBloc>().add(
                          FetchAssignmentById(
                            id: widget.assignmentId,
                            extended: true,
                          ),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<void> _exportAssignment(
    BuildContext context,
    AssignmentExtended assignment,
  ) async {
    // Show export options dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Assignment', style: GoogleFonts.poppins()),
        content: Text('Choose export format:', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performExport(context, 'PDF', assignment);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.picture_as_pdf, color: Colors.red),
                const SizedBox(width: 8),
                Text('PDF', style: GoogleFonts.poppins()),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performExport(context, 'CSV', assignment);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.table_chart, color: Colors.green),
                const SizedBox(width: 8),
                Text('CSV', style: GoogleFonts.poppins()),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  Future<void> _performExport(
    BuildContext context,
    String format,
    AssignmentExtended assignment,
  ) async {
    // Capture navigator and scaffold messenger before async operations
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    bool dialogShown = false;
    
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Exporting assignment as $format...',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
        ),
      );
      dialogShown = true;

      // Add timeout to prevent infinite loading
      Future<File> exportFuture;
      if (format == 'PDF') {
        exportFuture = AssignmentExportService.exportAssignmentPDF(assignment);
      } else {
        exportFuture = AssignmentExportService.exportAssignmentCSV(assignment);
      }

      // Wait for export with timeout
      final file = await exportFuture.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException(
            'Export operation timed out',
            const Duration(seconds: 30),
          );
        },
      );

      print('Export completed, file: ${file.path}');
      print('Widget mounted: $mounted, Context mounted: ${context.mounted}');

      // Close dialog first
      if (dialogShown && mounted) {
        print('Closing loading dialog...');
        navigator.pop();
        dialogShown = false;
        
        // Small delay to ensure dialog is closed before showing snackbar
        await Future.delayed(const Duration(milliseconds: 100));
        
        print('Showing success message...');
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              'Assignment "${assignment.title}" exported as $format successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        print('Success message shown');
      } else {
        print('Widget not mounted, cannot close dialog');
      }
    } catch (e) {
      print('Export error occurred: $e');
      print('Widget mounted: $mounted, Context mounted: ${context.mounted}');
      
      // Close dialog first if it was shown
      if (dialogShown && mounted) {
        print('Closing loading dialog after error...');
        navigator.pop();
        dialogShown = false;
        
        // Small delay to ensure dialog is closed before showing error
        await Future.delayed(const Duration(milliseconds: 100));

        String errorMessage = 'Failed to export assignment: ';
        if (e.toString().contains('timeout')) {
          errorMessage += 'Export timed out. Please try again.';
        } else if (e.toString().contains('permission')) {
          errorMessage += 'Permission denied. Check storage permissions.';
        } else {
          errorMessage += e.toString();
        }

        print('Showing error message...');
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
        print('Error message shown');
      } else {
        print('Widget not mounted, cannot close dialog after error');
      }
    }
  }

  Widget _buildQuestionSection({
    required String title,
    required String description,
    required List<Widget> children,
    required Color backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: backgroundColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileMCQTile(dynamic mcq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header with type and points
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'MCQ',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${mcq.points} pts',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Question text
          Text(
            mcq.question,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Options (without revealing correct answer)
          Column(
            children: mcq.options.asMap().entries.map<Widget>((entry) {
              int index = entry.key;
              String option = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + index), // A, B, C, D
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileMSQTile(dynamic msq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header with type and points
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'MSQ',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.green[700],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${msq.points} pts',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Question text
          Text(
            msq.question,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),

          // Multiple selection note
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Text(
              'Multiple answers possible',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.amber[700],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Options (without revealing correct answers)
          Column(
            children: msq.options.asMap().entries.map<Widget>((entry) {
              int index = entry.key;
              String option = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + index), // A, B, C, D
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNATTile(dynamic nat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header with type and points
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'NAT',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange[700],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${nat.points} pts',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Question text
          Text(
            nat.question,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),

          // Numerical input note
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Text(
              'Enter numerical answer',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.blue[700],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Answer input area (without showing solution)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Text(
                  'Answer: ',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        '___________',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileSubjectiveTile(dynamic subjective) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header with type and points
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Subjective',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.purple[700],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${subjective.points} pts',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Question text
          Text(
            subjective.question,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Answer area (without showing ideal answer or grading criteria)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Write your answer:',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      '...',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
