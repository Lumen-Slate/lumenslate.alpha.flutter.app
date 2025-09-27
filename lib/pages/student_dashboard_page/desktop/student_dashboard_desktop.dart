import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/student_classroom/student_classroom_bloc.dart';

class StudentDashboardDesktop extends StatefulWidget {
  const StudentDashboardDesktop({super.key});

  @override
  State<StudentDashboardDesktop> createState() => _StudentDashboardDesktopState();
}

class _StudentDashboardDesktopState extends State<StudentDashboardDesktop> {
  final TextEditingController _classCodeController = TextEditingController();
  late String _studentId;

  @override
  void initState() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthSignedInAsStudent) {
      context.read<AuthBloc>().add(SignOut());
      context.go('/');
    } else {
      _studentId = (authState).student.id;
    }
    super.initState();
    // Initialize paging for student classrooms
    context.read<StudentClassroomBloc>().add(
      InitializeStudentClassroomPaging(studentId: _studentId),
    );
  }

  void _showJoinClassDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Join a class'),
          content: TextField(
            controller: _classCodeController,
            decoration: const InputDecoration(labelText: 'Class code', border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _classCodeController.clear();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Join class using StudentClassroomBloc
                context.read<StudentClassroomBloc>().add(
                  JoinStudentClassroom(
                    studentId: _studentId,
                    classroomCode: _classCodeController.text,
                  ),
                );
                Navigator.of(context).pop();
                _classCodeController.clear();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Joining class...')));
              },
              child: const Text('Join'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildClassroomCard(dynamic classroom) {
    // classroom is a Map<String, dynamic>
    return SizedBox(
      height: 150,
      width: 300,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            // TODO: Navigate to classroom details
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(classroom['name'] ?? 'Classroom Name', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(classroom['classroomSubject'] ?? '', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const Spacer(),
                Text(
                  (classroom['teacherIds'] as List?)?.join(', ') ?? 'TeacherNames',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Classes'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SizedBox(
        child: BlocBuilder<StudentClassroomBloc, PagingState<int, dynamic>>(
          builder: (context, state) {
            return PagedListView<int, dynamic>(
              state: state,
              fetchNextPage: () {
                context.read<StudentClassroomBloc>().add(
                  FetchNextStudentClassroomPage(studentId: _studentId),
                );
              },
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) => _buildClassroomCard(item),
                noItemsFoundIndicatorBuilder: (context) =>
                    const Center(child: Text('No classes joined yet.')),
                firstPageErrorIndicatorBuilder: (context) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('Failed to load classes', style: TextStyle(fontSize: 18, color: Colors.red)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          context.read<StudentClassroomBloc>().add(
                            InitializeStudentClassroomPaging(studentId: _studentId),
                          );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showJoinClassDialog,
        icon: const Icon(Icons.add),
        label: const Text('Join class'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
