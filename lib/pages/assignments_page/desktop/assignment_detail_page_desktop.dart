import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lumen_slate/lib.dart';
import 'package:lumen_slate/models/extended/assignment_extended.dart';
import 'package:lumen_slate/pages/questions_page/desktop/components/question_tiles/mcq_tile.dart';
import 'package:lumen_slate/pages/questions_page/desktop/components/question_tiles/msq_tile.dart';
import 'package:lumen_slate/pages/questions_page/desktop/components/question_tiles/nat_tile.dart';
import '../../../blocs/assignment/assignment_bloc.dart';
import '../../../services/assignment_export_service.dart';
import '../../questions_page/desktop/components/question_tiles/subjective_tile.dart';

class AssignmentDetailPageDesktop extends StatefulWidget {
  final String assignmentId;

  const AssignmentDetailPageDesktop({super.key, required this.assignmentId});

  @override
  State<AssignmentDetailPageDesktop> createState() => _AssignmentDetailPageDesktopState();
}

class _AssignmentDetailPageDesktopState extends State<AssignmentDetailPageDesktop> {
  @override
  void initState() {
    context.read<AssignmentBloc>().add(FetchAssignmentById(id: widget.assignmentId, extended: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (result, __) {
        if (result) {
          context.read<AssignmentBloc>().add(InitializeAssignmentPaging(extended: false));
        }
      },
      child: ResponsiveScaledBox(
        width: AppConstants.desktopScaleWidth,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(backgroundColor: Colors.white),
          body: BlocBuilder<AssignmentBloc, AssignmentState>(
            builder: (context, state) {
              if (state is AssignmentSingleExtendedSuccess) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  child: Column(
                    spacing: 30,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 30,
                            children: [
                              Text(
                                state.assignment.title,
                                style: GoogleFonts.poppins(fontSize: 58, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 70,
                                width: 240,
                                child: FilledButton.tonal(
                                  onPressed: () => _exportAssignment(context, state.assignment),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade300,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 8,
                                    children: [
                                      Text('Export', style: GoogleFonts.poppins(fontSize: 26)),
                                      const Icon(Icons.file_download, size: 32),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(state.assignment.body, style: GoogleFonts.poppins(fontSize: 22)),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Text(
                              "Due: ${DateFormat('dd-MM-yyyy').format(state.assignment.dueDate)}",
                              style: GoogleFonts.poppins(color: Colors.red[400]),
                            ),
                          ),
                        ],
                      ),
                      if (state.assignment.mcqs != null && state.assignment.mcqs!.isNotEmpty)
                        _buildQuestionSection(
                          title: "Multiple Choice Questions",
                          description: "Choose the correct option. Only one answer is correct.",
                          backgroundColor: Colors.blue,
                          children: state.assignment.mcqs!
                              .map(
                                (q) => Container(
                                  margin: const EdgeInsets.only(bottom: 40),
                                  child: MCQTile(mcq: q, viewOnly: true),
                                ),
                              )
                              .toList(),
                        ),
                      if (state.assignment.msqs != null && state.assignment.msqs!.isNotEmpty)
                        _buildQuestionSection(
                          title: "Multiple Select Questions",
                          description: "Select all correct options. More than one may apply.",
                          backgroundColor: Colors.green,
                          children: state.assignment.msqs!.map((q) => Container(
                              margin: const EdgeInsets.only(bottom: 40),
                              child: MSQTile(msq: q, viewOnly: true))).toList(),
                        ),
                      if (state.assignment.nats != null && state.assignment.nats!.isNotEmpty)
                        _buildQuestionSection(
                          title: "Numerical Answer Type",
                          description: "Type the numerical answer without options.",
                          backgroundColor: Colors.orange,
                          children: state.assignment.nats!.map((q) => Container(
                              margin: const EdgeInsets.only(bottom: 40),
                              child: NATTile(nat: q, viewOnly: true))).toList(),
                        ),
                      if (state.assignment.subjectives != null && state.assignment.subjectives!.isNotEmpty)
                        _buildQuestionSection(
                          title: "Subjective Questions",
                          description: "Write descriptive answers in your own words.",
                          backgroundColor: Colors.purple,
                          children: state.assignment.subjectives!
                              .map((q) => Container(
                              margin: const EdgeInsets.only(bottom: 40),
                              child: SubjectiveTile(subjective: q, viewOnly: true)))
                              .toList(),
                        ),

                      /// Comments Section
                      if (state.assignment.comments != null && state.assignment.comments!.isNotEmpty)
                        _buildQuestionSection(
                          title: "Comments",
                          description: "Remarks or feedback related to this assignment.",
                          backgroundColor: Colors.grey,
                          isLast: true,
                          children: state.assignment.comments!.map((comment) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 16)),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(comment.commentBody, style: GoogleFonts.poppins(fontSize: 14))),
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
                  child: Text(
                    'Failed to load assignment: ${state.error}',
                    style: GoogleFonts.poppins(color: Colors.red),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _exportAssignment(BuildContext context, AssignmentExtended assignment) async {
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

  Future<void> _performExport(BuildContext context, String format, AssignmentExtended assignment) async {
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
              Text('Exporting assignment as $format...', style: GoogleFonts.poppins()),
            ],
          ),
        ),
      );

      if (format == 'PDF') {
        await AssignmentExportService.exportAssignmentPDF(assignment);
      } else {
        await AssignmentExportService.exportAssignmentCSV(assignment);
      }

      Navigator.of(context).pop(); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Assignment "${assignment.title}" exported as $format successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to export assignment: $e'), backgroundColor: Colors.red));
    }
  }

  Widget _buildQuestionSection({
    required String title,
    required String description,
    required List<Widget> children,
    required Color backgroundColor,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(38),
          decoration: BoxDecoration(
            color: backgroundColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 38, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(description, style: GoogleFonts.poppins(fontSize: 26, color: Colors.grey[600])),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      ],
    );
  }
}
