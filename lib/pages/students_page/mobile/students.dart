import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../blocs/student/student_bloc.dart';
import '../../../blocs/classroom/classroom_bloc.dart';
import '../../../models/students.dart';
import '../../../models/classroom.dart';
import 'widget/student_card.dart';

class StudentsPageMobile extends StatefulWidget {
  final String classroomId;

  const StudentsPageMobile({super.key, required this.classroomId});

  @override
  State<StudentsPageMobile> createState() => _StudentsPageMobileState();
}

class _StudentsPageMobileState extends State<StudentsPageMobile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Classroom? _classroom;
  final TextEditingController _searchController = TextEditingController();
  String _currentSearchQuery = '';

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
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Students',
                style: GoogleFonts.poppins(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard', style: GoogleFonts.poppins(fontSize: 16)),
              onTap: () => context.go('/teacher-dashboard'),
            ),
            ListTile(
              leading: Icon(Icons.class_),
              title: Text('Classrooms', style: GoogleFonts.poppins(fontSize: 16)),
              onTap: () => context.go('/teacher-dashboard/classrooms'),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Assignments', style: GoogleFonts.poppins(fontSize: 16)),
              onTap: () => context.go('/teacher-dashboard/assignments'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: BlocListener<ClassroomBloc, ClassroomState>(
          listener: (context, state) {
            if (state is ClassroomSingleOriginalSuccess) {
              setState(() {
                _classroom = state.classroom;
              });
            }
          },
          child: Text(
            _classroom != null 
              ? "Students in ${_classroom!.subject}"
              : "Loading...",
            style: GoogleFonts.poppins(),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add student page
        },
        child: const Icon(Icons.person_add),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              controller: _searchController,
              leading: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.search),
              ),
              backgroundColor: WidgetStateProperty.all(Colors.white),
              hintText: "Search students by name, email, or roll number",
              hintStyle: WidgetStateProperty.all(
                GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
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
              ],
            ),
          ),
          // Students list
          Expanded(
            child: BlocBuilder<StudentBloc, StudentState>(
              builder: (context, state) {
                if (state is StudentOriginalSuccess) {
                  return PagedListView<int, Student>(
                    state: state.pagingState,
                    fetchNextPage: () {
                      context.read<StudentBloc>().add(
                        FetchNextStudentPage(
                          classIds: widget.classroomId,
                          searchQuery: _currentSearchQuery.isEmpty ? null : _currentSearchQuery,
                        ),
                      );
                    },
                    builderDelegate: PagedChildBuilderDelegate<Student>(
                      itemBuilder: (context, item, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: StudentCardMobile(
                          student: item,
                          index: index,
                        ),
                      ),
                      noItemsFoundIndicatorBuilder: (context) => const Center(
                        child: Text("No students found in this classroom."),
                      ),
                      firstPageErrorIndicatorBuilder: (context) => const Center(
                        child: Text("Error loading students"),
                      ),
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
    );
  }
}
