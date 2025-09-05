import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lumen_slate/lib.dart';
import '../../../../blocs/assignment/assignment_bloc.dart';
import '../../../../models/assignments.dart';

class AssignmentSelectionDialog extends StatefulWidget {
  final void Function(Assignment)? onAssignmentSelected;
  final String teacherId;

  const AssignmentSelectionDialog({super.key, this.onAssignmentSelected, required this.teacherId});

  @override
  State<AssignmentSelectionDialog> createState() => _AssignmentSelectionDialogState();
}

class _AssignmentSelectionDialogState extends State<AssignmentSelectionDialog> {
  @override
  void initState() {
    context.read<AssignmentBloc>().add(InitializeAssignmentPaging(extended: false, teacherId: widget.teacherId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: AppConstants.desktopScaleWidth,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: SizedBox(
          width: 1200,
          height: 800,
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
                        'Select an Assignment',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 64, fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(30)),
                      child: BlocBuilder<AssignmentBloc, AssignmentState>(
                        builder: (context, state) {
                          if (state is AssignmentOriginalSuccess) {
                            return PagedListView<int, Assignment>(
                              state: state.pagingState,
                              fetchNextPage: () {
                                context.read<AssignmentBloc>().add(FetchNextAssignmentPage(teacherId: widget.teacherId));
                              },
                              builderDelegate: PagedChildBuilderDelegate(
                                itemBuilder: (context, assignment, index) => Container(
                                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.all(14.0),
                                  child: ListTile(
                                    title: Text(
                                      assignment.title ?? 'Untitled',
                                      style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: assignment.body != null
                                        ? Text(assignment.body, style: GoogleFonts.poppins(fontSize: 16))
                                        : null,
                                    onTap: () {
                                      if (widget.onAssignmentSelected != null) {
                                        widget.onAssignmentSelected!(assignment);
                                      }
                                      context.pop(assignment);
                                    },
                                  ),
                                ),
                                noItemsFoundIndicatorBuilder: (context) => Center(child: Text('No assignments found')),
                                firstPageErrorIndicatorBuilder: (context) =>
                                    Center(child: Text('Error loading assignments')),
                              ),
                            );
                          } else if (state is AssignmentFailure) {
                            return Center(child: Text('Failed to load assignments'));
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
      ),
    );
  }
}
