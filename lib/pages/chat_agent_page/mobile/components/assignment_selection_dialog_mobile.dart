import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../blocs/assignment/assignment_bloc.dart';
import '../../../../models/assignments.dart';

class AssignmentSelectionDialogMobile extends StatefulWidget {
  final void Function(Assignment)? onAssignmentSelected;
  final String teacherId = '0692d515-1621-44ea-85e7-a41335858ee2'; // TODO: Replace with actual teacher ID

  const AssignmentSelectionDialogMobile({super.key, this.onAssignmentSelected});

  @override
  State<AssignmentSelectionDialogMobile> createState() => _AssignmentSelectionDialogMobileState();
}

class _AssignmentSelectionDialogMobileState extends State<AssignmentSelectionDialogMobile> {
  @override
  void initState() {
    super.initState();
    context.read<AssignmentBloc>().add(InitializeAssignmentPaging(extended: false, teacherId: widget.teacherId));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Select Assignment',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<AssignmentBloc, AssignmentState>(
            builder: (context, state) {
              if (state is AssignmentOriginalSuccess) {
                return PagedListView<int, Assignment>(
                  state: state.pagingState,
                  fetchNextPage: () {
                    context.read<AssignmentBloc>().add(
                      FetchNextAssignmentPage(teacherId: widget.teacherId),
                    );
                  },
                  builderDelegate: PagedChildBuilderDelegate<Assignment>(
                    itemBuilder: (context, assignment, index) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange[100],
                          child: Icon(
                            Icons.assignment,
                            color: Colors.orange[800],
                          ),
                        ),
                        title: Text(
                          assignment.title ?? 'Untitled Assignment',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: assignment.body != null
                            ? Text(
                                assignment.body!,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          if (widget.onAssignmentSelected != null) {
                            widget.onAssignmentSelected!(assignment);
                          }
                          context.pop(assignment);
                        },
                      ),
                    ),
                    noItemsFoundIndicatorBuilder: (context) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No assignments found',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    firstPageErrorIndicatorBuilder: (context) => Center(
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
                            'Error loading assignments',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.red[600],
                            ),
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
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load assignments',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.red[600],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
