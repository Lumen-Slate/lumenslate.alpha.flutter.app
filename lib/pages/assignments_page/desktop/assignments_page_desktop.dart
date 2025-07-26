import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lumen_slate/lib.dart';
import '../../../blocs/assignment/assignment_bloc.dart';
import 'widgets/assignment_tile_desktop.dart';
import '../../../models/assignments.dart';

class AssignmentsPageDesktop extends StatefulWidget {
  const AssignmentsPageDesktop({super.key});

  @override
  State<AssignmentsPageDesktop> createState() => _AssignmentsPageDesktopState();
}

class _AssignmentsPageDesktopState extends State<AssignmentsPageDesktop> {
  final String _teacherId = '0692d515-1621-44ea-85e7-a41335858ee2';

  @override
  void initState() {
    context.read<AssignmentBloc>().add(InitializeAssignmentPaging(extended: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: AppConstants.desktopScaleWidth,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Add create assignment functionality
          },
          backgroundColor: Colors.orange[600],
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: AutoSizeText(
                    "Assignments",
                    maxLines: 2,
                    minFontSize: 80,
                    style: GoogleFonts.poppins(fontSize: 80),
                  ),
                ),
                const SizedBox(height: 50),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100], 
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      // Search Bar (disabled for now, as pagination is server-side)
                      Row(
                        children: [
                          Expanded(
                            child: SearchBar(
                              onChanged: (_) {},
                              leading: const Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Icon(Icons.search),
                              ),
                              backgroundColor: WidgetStateProperty.all(Colors.white),
                              hintText: "Search assignments",
                              hintStyle: WidgetStateProperty.all(
                                GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                              ),
                              enabled: false, // Disabled for paginated list
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Paginated Assignments List
                      SizedBox(
                        height: 580,
                        child: BlocBuilder<AssignmentBloc, AssignmentState>(
                          builder: (context, state) {
                            if (state is AssignmentOriginalSuccess) {
                              return PagedListView<int, Assignment>(
                                state: state.pagingState,
                                fetchNextPage: () {
                                  context.read<AssignmentBloc>().add(
                                    FetchNextAssignmentPage(teacherId: _teacherId, extended: false),
                                  );
                                },
                                builderDelegate: PagedChildBuilderDelegate(
                                  itemBuilder: (context, item, index) => AssignmentTileDesktop(assignment: item),
                                  noItemsFoundIndicatorBuilder: (context) => Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.assignment, size: 64, color: Colors.grey[400]),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No assignments found',
                                          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  firstPageErrorIndicatorBuilder: (context) => Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Error loading assignments',
                                          style: GoogleFonts.poppins(fontSize: 18, color: Colors.red[600]),
                                        ),
                                        const SizedBox(height: 12),
                                        ElevatedButton(
                                          onPressed: () {
                                            context.read<AssignmentBloc>().add(
                                              InitializeAssignmentPaging(extended: false),
                                            );
                                          },
                                          child: const Text('Retry'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else if (state is AssignmentFailure) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Error: ${state.error}',
                                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.red[600]),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.read<AssignmentBloc>().add(
                                          InitializeAssignmentPaging(extended: false),
                                        );
                                      },
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[600]!),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
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
