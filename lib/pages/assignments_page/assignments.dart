import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lumen_slate/lib.dart';
import '../../blocs/assignment/assignment_bloc.dart';
import 'widget/assignment_tile.dart';
import '../../models/assignments.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
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
        floatingActionButton: FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
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
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: [
                      // Search Bar (disabled for now, as pagination is server-side)
                      Row(
                        children: [
                          Expanded(
                            child: SearchBar(
                              onChanged: (_) {},
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: const Icon(Icons.search),
                              ),
                              backgroundColor: WidgetStateProperty.all(Colors.white),
                              hintText: "Search assignments",
                              hintStyle: WidgetStateProperty.all(GoogleFonts.poppins(fontSize: 16, color: Colors.black)),
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
                                  itemBuilder: (context, item, index) => AssignmentTile(assignment: item),
                                  noItemsFoundIndicatorBuilder: (context) => Center(child: Text('No assignments found')),
                                  firstPageErrorIndicatorBuilder: (context) =>
                                      Center(child: Text('Error loading assignments')),
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
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
