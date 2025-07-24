import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../blocs/student/student_bloc.dart';
import '../../../models/students.dart';
import 'widgets/performance_reports_section.dart';
import 'widgets/assignment_reports_section.dart';

class StudentDetailPageDesktop extends StatefulWidget {
  final String studentId;
  final String classroomId;

  const StudentDetailPageDesktop({
    super.key,
    required this.studentId,
    required this.classroomId,
  });

  @override
  State<StudentDetailPageDesktop> createState() =>
      _StudentDetailPageDesktopState();
}

class _StudentDetailPageDesktopState extends State<StudentDetailPageDesktop> {
  Student? _student;

  @override
  void initState() {
    super.initState();
    // Fetch student details
    context.read<StudentBloc>().add(
      FetchStudentById(id: widget.studentId, extended: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (result, object) {
        // Reinitialize student paging when navigating back to students list
        context.read<StudentBloc>().add(
          InitializeStudentPaging(
            extended: false,
            classIds: widget.classroomId,
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with student name
              Row(
                children: [
                  Expanded(
                    child: BlocListener<StudentBloc, StudentState>(
                      listener: (context, state) {
                        if (state is StudentSingleOriginalSuccess) {
                          setState(() {
                            _student = state.student;
                          });
                        }
                      },
                      child: Text(
                        _student != null ? _student!.name : 'Loading...',
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              // Main content
              Expanded(
                child: BlocBuilder<StudentBloc, StudentState>(
                  builder: (context, state) {
                    if (state is StudentSingleOriginalSuccess) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Performance Reports Section
                          Expanded(
                            child: PerformanceReportsSection(
                              student: state.student,
                              classroomId: widget.classroomId,
                            ),
                          ),
                          const SizedBox(width: 40),
                          // Assignment Reports Section
                          Expanded(
                            child: AssignmentReportsSection(
                              student: state.student,
                              classroomId: widget.classroomId,
                            ),
                          ),
                        ],
                      );
                    } else if (state is StudentSingleFailure) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Failed to load student details',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.red[400],
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
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
