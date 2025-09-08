import 'package:auto_size_text/auto_size_text.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lumen_slate/lib.dart';
import 'package:lumen_slate/pages/classrooms_page/desktop/widget/classroom_tile.dart';

import '../../../blocs/classroom/classroom_bloc.dart';
import '../../../models/classroom.dart';

class ClassroomsPageDesktop extends StatefulWidget {
  const ClassroomsPageDesktop({super.key});

  @override
  State<ClassroomsPageDesktop> createState() => _ClassroomsPageDesktopState();
}

class _ClassroomsPageDesktopState extends State<ClassroomsPageDesktop> {
  final int _pageSize = 10;

  int _getCrossAxisCount(double screenWidth) {
    if (screenWidth >= 1200) {
      return 3;
    } else if (screenWidth >= 800) {
      return 2;
    }
    return 1;
  }

  @override
  void initState() {
    super.initState();
    context.read<ClassroomBloc>().add(
      InitializeClassroomPaging(extended: false),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      String teacherId = '';
      if (authState is AuthSignedInAsTeacher) {
        teacherId = authState.teacher.id;
      }
      context.read<ClassroomBloc>().add(
        FetchNextClassroomPage(
          teacherId: teacherId,
          pageSize: _pageSize,
          extended: false,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<AuthBloc>().state is! AuthSignedInAsTeacher) {
      context.read<AuthBloc>().add(SignOut());
      context.go('/');
      return const SizedBox.shrink();
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final authState = context.watch<AuthBloc>().state;
    String teacherId = '';
    if (authState is AuthSignedInAsTeacher) {
      teacherId = authState.teacher.id;
    }

    return BlocBuilder<ClassroomBloc, ClassroomState>(
      builder: (context, state) {
        return ResponsiveScaledBox(
          width: AppConstants.desktopScaleWidth,
          child: PopScope(
            onPopInvokedWithResult: (result, object) {},
            child: Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      final nameController = TextEditingController();
                      final creditsController = TextEditingController();
                      final tagsController = TextEditingController();
                      final subjectController = TextEditingController();
                      return AlertDialog(
                        title: const Text('Create Classroom'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                ),
                              ),
                              TextField(
                                controller: creditsController,
                                decoration: const InputDecoration(
                                  labelText: 'Credits',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              TextField(
                                controller: tagsController,
                                decoration: const InputDecoration(
                                  labelText: 'Tags (comma separated)',
                                ),
                              ),
                              TextField(
                                controller: subjectController,
                                decoration: const InputDecoration(
                                  labelText: 'Classroom Subject',
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              List<String> missingFields = [];
                              if (nameController.text.isEmpty) {
                                missingFields.add('Name');
                              }
                              if (teacherId.isEmpty) {
                                missingFields.add('Teacher ID');
                              }
                              if (creditsController.text.isEmpty) {
                                missingFields.add('Credits');
                              }
                              if (missingFields.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Required: ${missingFields.join(', ')}',
                                    ),
                                  ),
                                );
                                return;
                              }
                              final classroom = Classroom(
                                id: '',
                                name: nameController.text,
                                teacherIds: [teacherId],
                                assignmentIds: [],
                                credits:
                                    int.tryParse(creditsController.text) ?? 0,
                                tags: tagsController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .where((e) => e.isNotEmpty)
                                    .toList(),
                                classroomSubject:
                                    subjectController.text.isNotEmpty
                                    ? subjectController.text
                                    : null,
                              );
                              context.read<ClassroomBloc>().add(
                                CreateClassroom(
                                  teacherId: teacherId,
                                  classroom: classroom,
                                ),
                              );
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Classroom created successfully',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Text('Create'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(Icons.add),
              ),
              body: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 50,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: AutoSizeText(
                        "Classrooms",
                        maxLines: 2,
                        minFontSize: 80,
                        style: GoogleFonts.poppins(fontSize: 80),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Expanded(
                      child: Builder(
                        builder: (_) {
                          if (state is ClassroomOriginalSuccess) {
                            return PagedGridView<int, Classroom>(
                              showNewPageProgressIndicatorAsGridChild: false,
                              showNewPageErrorIndicatorAsGridChild: false,
                              showNoMoreItemsIndicatorAsGridChild: false,
                              state: state.pagingState,
                              fetchNextPage: () {
                                context.read<ClassroomBloc>().add(
                                  FetchNextClassroomPage(
                                    teacherId: teacherId,
                                    pageSize: _pageSize,
                                    extended: false,
                                  ),
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: _getCrossAxisCount(
                                      screenWidth,
                                    ),
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,
                                    childAspectRatio: 2.0,
                                  ),
                              builderDelegate:
                                  PagedChildBuilderDelegate<Classroom>(
                                    itemBuilder: (context, item, index) =>
                                        ClassroomTile(
                                          classroom: item,
                                          teacherNames: const [],
                                          classroomAssignments: const [],
                                          index: index,
                                        ),
                                    noItemsFoundIndicatorBuilder: (context) =>
                                        const Center(
                                          child: Text("No classrooms found."),
                                        ),
                                    firstPageErrorIndicatorBuilder: (context) =>
                                        const Center(
                                          child: Text(
                                            "Error loading classrooms",
                                          ),
                                        ),
                                  ),
                            );
                          }
                          if (state is ClassroomFailure) {
                            return Center(
                              child: Text('Error loading classrooms'),
                            );
                          }
                          if (state is ClassroomInitial) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
