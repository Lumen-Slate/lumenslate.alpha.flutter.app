import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../blocs/student/student_bloc.dart';
import '../../../models/students.dart';
import 'widgets/performance_reports_section.dart';
import 'widgets/assignment_reports_section.dart';

class StudentDetailPageMobile extends StatefulWidget {
  final String studentId;
  final String classroomId;

  const StudentDetailPageMobile({
    super.key,
    required this.studentId,
    required this.classroomId,
  });

  @override
  State<StudentDetailPageMobile> createState() => _StudentDetailPageMobileState();
}

class _StudentDetailPageMobileState extends State<StudentDetailPageMobile> {
  Student? _student;

  @override
  void initState() {
    super.initState();
    // Fetch student details
    context.read<StudentBloc>().add(FetchStudentById(id: widget.studentId, extended: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: BlocListener<StudentBloc, StudentState>(
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
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentSingleOriginalSuccess) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Performance Reports Section
                  PerformanceReportsSectionMobile(
                    student: state.student,
                    classroomId: widget.classroomId,
                  ),
                  const SizedBox(height: 24),
                  // Assignment Reports Section
                  AssignmentReportsSectionMobile(
                    student: state.student,
                    classroomId: widget.classroomId,
                  ),
                ],
              ),
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
