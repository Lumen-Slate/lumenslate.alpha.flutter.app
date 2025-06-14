import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../blocs/student/student_bloc.dart';
import '../../../../models/students.dart';

class StudentSelectionDialog extends StatefulWidget {
  final void Function(Student)? onStudentSelected;

  const StudentSelectionDialog({super.key, this.onStudentSelected});

  @override
  State<StudentSelectionDialog> createState() => _StudentSelectionDialogState();
}

class _StudentSelectionDialogState extends State<StudentSelectionDialog> {
  @override
  void initState() {
    context.read<StudentBloc>().add(InitializeStudentPaging(extended: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: SizedBox(
        width: 1600,
        height: 900,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(50.0),
                    child: Text(
                      'Select a Student',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 106, fontWeight: FontWeight.w400, color: Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(30)),
                    child: BlocBuilder<StudentBloc, StudentState>(
                      builder: (context, state) {
                        if (state is StudentOriginalSuccess) {
                          return PagedListView<int, Student>(
                            state: state.pagingState,
                            fetchNextPage: () {
                              context.read<StudentBloc>().add(FetchNextStudentPage());
                            },
                            builderDelegate: PagedChildBuilderDelegate(
                              itemBuilder: (context, student, index) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.all(14.0),
                                child: ListTile(
                                  title: Text(student.name, style: GoogleFonts.poppins(fontSize: 24)),
                                  subtitle: Text(student.email, style: GoogleFonts.poppins(fontSize: 18)),
                                  onTap: () {
                                    if (widget.onStudentSelected != null) {
                                      widget.onStudentSelected!(student);
                                    }
                                    context.pop(student);
                                  },
                                ),
                              ),
                              noItemsFoundIndicatorBuilder: (context) => Center(child: Text('No students found')),
                              firstPageErrorIndicatorBuilder: (context) =>
                                  Center(child: Text('Error loading students')),
                            ),
                          );
                        } else if (state is StudentFailure) {
                          return Center(child: Text('Failed to load students'));
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
