import 'package:auto_size_text/auto_size_text.dart';
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
  final String _teacherId = '0692d515-1621-44ea-85e7-a41335858ee2';

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
    context.read<ClassroomBloc>().add(InitializeClassroomPaging(extended: false));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<ClassroomBloc, ClassroomState>(
      builder: (context, state) {
        return ResponsiveScaledBox(
          width: AppConstants.desktopScaleWidth,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
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
                                  teacherId: _teacherId,
                                  pageSize: _pageSize,
                                  extended: false,
                                ),
                              );
                            },
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _getCrossAxisCount(screenWidth),
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              childAspectRatio: 2.0,
                            ),
                            builderDelegate: PagedChildBuilderDelegate<Classroom>(
                              itemBuilder: (context, item, index) => ClassroomTile(
                                classroom: item,
                                teacherNames: const [],
                                classroomAssignments: const [],
                                index: index,
                              ),
                              noItemsFoundIndicatorBuilder: (context) =>
                                  const Center(child: Text("No classrooms found.")),
                              firstPageErrorIndicatorBuilder: (context) =>
                                  const Center(child: Text("Error loading classrooms")),
                            ),
                          );
                        }
                        // ...existing code for loading, error, etc...
                        if (state is ClassroomFailure) {
                          return Center(child: Text('Error loading classrooms'));
                        }
                        if (state is ClassroomInitial) {
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
      },
    );
  }
}
