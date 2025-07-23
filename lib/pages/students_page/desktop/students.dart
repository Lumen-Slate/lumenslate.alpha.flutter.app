import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../blocs/student/student_bloc.dart';
import '../../../blocs/classroom/classroom_bloc.dart';
import '../../../models/students.dart';
import '../../../models/classroom.dart';
import 'widget/student_tile.dart';

class StudentsPageDesktop extends StatefulWidget {
  final String classroomId;

  const StudentsPageDesktop({super.key, required this.classroomId});

  @override
  State<StudentsPageDesktop> createState() => _StudentsPageDesktopState();
}

class _StudentsPageDesktopState extends State<StudentsPageDesktop> {
  final int _pageSize = 10;
  Classroom? _classroom;
  final TextEditingController _searchController = TextEditingController();
  String _currentSearchQuery = '';
  String _currentEmailFilter = '';
  String _currentRollNoFilter = '';

  void _performSearch() {
    final query = _searchController.text.trim();
    setState(() {
      _currentSearchQuery = query;
    });

    if (query.isEmpty) {
      // Reset to original list without search
      context.read<StudentBloc>().add(InitializeStudentPaging(
        extended: false,
        classIds: widget.classroomId,
      ));
    } else {
      // Perform search
      context.read<StudentBloc>().add(SearchStudents(
        searchQuery: query,
        classIds: widget.classroomId,
        extended: false,
      ));
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _currentSearchQuery = '';
    });
    context.read<StudentBloc>().add(InitializeStudentPaging(
      extended: false,
      classIds: widget.classroomId,
    ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAdvancedFiltersDialog() {
    final emailController = TextEditingController(text: _currentEmailFilter);
    final rollNoController = TextEditingController(text: _currentRollNoFilter);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.tune, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Advanced Filters',
                    style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Filter by Email',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter email address',
                  prefixIcon: const Icon(Icons.email),
                  border: const OutlineInputBorder(),
                  hintStyle: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Filter by Roll Number',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: rollNoController,
                decoration: InputDecoration(
                  hintText: 'Enter roll number',
                  prefixIcon: const Icon(Icons.numbers),
                  border: const OutlineInputBorder(),
                  hintStyle: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        emailController.clear();
                        rollNoController.clear();
                        setState(() {
                          _currentEmailFilter = '';
                          _currentRollNoFilter = '';
                        });
                        Navigator.of(context).pop();
                        context.read<StudentBloc>().add(InitializeStudentPaging(
                          extended: false,
                          classIds: widget.classroomId,
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                      ),
                      child: Text('Clear Filters', style: GoogleFonts.poppins()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentEmailFilter = emailController.text.trim();
                          _currentRollNoFilter = rollNoController.text.trim();
                        });
                        Navigator.of(context).pop();
                        context.read<StudentBloc>().add(SearchStudents(
                          email: _currentEmailFilter.isEmpty ? null : _currentEmailFilter,
                          rollNo: _currentRollNoFilter.isEmpty ? null : _currentRollNoFilter,
                          searchQuery: _currentSearchQuery.isEmpty ? null : _currentSearchQuery,
                          classIds: widget.classroomId,
                          extended: false,
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Apply Filters', style: GoogleFonts.poppins()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      emailController.dispose();
      rollNoController.dispose();
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch classroom details first
    context.read<ClassroomBloc>().add(FetchClassroomById(id: widget.classroomId, extended: false));
    // Initialize student paging with classIds filter
    context.read<StudentBloc>().add(InitializeStudentPaging(
      extended: false,
      classIds: widget.classroomId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (result,object) {
        context.read<ClassroomBloc>().add(InitializeClassroomPaging(extended: false));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: BlocListener<ClassroomBloc, ClassroomState>(
                      listener: (context, state) {
                        if (state is ClassroomSingleOriginalSuccess) {
                          setState(() {
                            _classroom = state.classroom;
                          });
                        }
                      },
                      child: Column(
                        spacing: 16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            _classroom != null
                              ? _classroom!.subject
                              : "Loading Classroom...",
                            maxLines: 2,
                            minFontSize: 80,
                            style: GoogleFonts.poppins(fontSize: 80),
                          ),
                          AutoSizeText(
                            "Browse and manage students in this classroom",
                            maxLines: 1,
                            minFontSize: 24,
                            style: GoogleFonts.poppins(fontSize: 24, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              // Search bar with filters
              Row(
                children: [
                  Expanded(
                    child: SearchBar(
                      controller: _searchController,
                      leading: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.search),
                      ),
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      hintText: "Search students by name, email, or roll number",
                      hintStyle: WidgetStateProperty.all(
                        GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
                      ),
                      onSubmitted: (value) => _performSearch(),
                      trailing: [
                        if (_currentSearchQuery.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearSearch,
                            tooltip: 'Clear search',
                          ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _performSearch,
                          tooltip: 'Search',
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.filter_list),
                          tooltip: 'Advanced filters',
                          onSelected: (value) {
                            _showAdvancedFiltersDialog();
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'filters',
                              child: Row(
                                children: [
                                  Icon(Icons.tune),
                                  SizedBox(width: 8),
                                  Text('Advanced Filters'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: BlocBuilder<StudentBloc, StudentState>(
                  builder: (context, state) {
                    if (state is StudentOriginalSuccess) {
                      return PagedListView<int, Student>(
                        state: state.pagingState,
                        fetchNextPage: () {
                          context.read<StudentBloc>().add(
                            FetchNextStudentPage(
                              pageSize: _pageSize,
                              classIds: widget.classroomId,
                              email: _currentEmailFilter.isEmpty ? null : _currentEmailFilter,
                              rollNo: _currentRollNoFilter.isEmpty ? null : _currentRollNoFilter,
                              searchQuery: _currentSearchQuery.isEmpty ? null : _currentSearchQuery,
                            ),
                          );
                        },
                        builderDelegate: PagedChildBuilderDelegate<Student>(
                          itemBuilder: (context, item, index) => Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: StudentTile(
                              student: item,
                              index: index,
                            ),
                          ),
                        );
                      },
                      builderDelegate: PagedChildBuilderDelegate<Student>(
                        itemBuilder: (context, item, index) => StudentTile(
                          student: item,
                          index: index,
                          classroomId: widget.classroomId,

                          noItemsFoundIndicatorBuilder: (context) =>
                              const Center(child: Text("No students found in this classroom.")),
                          firstPageErrorIndicatorBuilder: (context) =>
                              const Center(child: Text("Error loading students")),

                        ),
                      );
                    }
                    if (state is StudentFailure) {
                      return Center(child: Text('Error loading students: ${state.error}'));
                    }
                    if (state is StudentInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const SizedBox.shrink();
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
