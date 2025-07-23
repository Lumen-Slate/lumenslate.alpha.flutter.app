import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:lumen_slate/models/classroom.dart';

class ClassroomTile extends StatefulWidget {
  final Classroom classroom;
  final List<String> teacherNames;
  final List<dynamic> classroomAssignments;
  final int index;

  const ClassroomTile({
    super.key,
    required this.classroom,
    required this.teacherNames,
    required this.classroomAssignments,
    required this.index,
  });

  @override
  State<ClassroomTile> createState() => _ClassroomTileState();
}

class _ClassroomTileState extends State<ClassroomTile> {
  final _toolTipController = JustTheController();
  bool _isOverflowing = false;

  @override
  Widget build(BuildContext context) {
    int maxLines = 1;
    double fontSize = 46.0;

    return MouseRegion(
      opaque: false,
      onEnter: (event) {
        if (_isOverflowing && _toolTipController.value == TooltipStatus.isHidden) {
          _toolTipController.showTooltip();
        }
      },
      onExit: (event) {
        if (_toolTipController.value == TooltipStatus.isShowing) {
          _toolTipController.hideTooltip();
        }
      },
      child: FilledButton.tonal(
        onPressed: () {
          context.go('/teacher-dashboard/classrooms/${widget.classroom.id}/students');
        },
        style: FilledButton.styleFrom(
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0)),
          padding: const EdgeInsets.all(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, size) {
                  TextSpan span = TextSpan(
                    text: widget.classroom.subject,
                    style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight.w600),
                  );
                  TextPainter tp = TextPainter(
                    maxLines: maxLines,
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                    text: span,
                  );
                  tp.layout(maxWidth: size.maxWidth);
                  _isOverflowing = tp.didExceedMaxLines;

                  if (_isOverflowing) {
                    return JustTheTooltip(
                      triggerMode: TooltipTriggerMode.manual,
                      controller: _toolTipController,
                      preferredDirection: AxisDirection.up,
                      content: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10.0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.classroom.subject,
                          style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w400),
                        ),
                      ),
                      child: Text(
                        widget.classroom.subject,
                        maxLines: maxLines,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight.w600),
                      ),
                    );
                  } else {
                    return Text(
                      widget.classroom.subject,
                      maxLines: maxLines,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight.w600),
                    );
                  }
                },
              ),
              Text(
                'Teachers: ${widget.classroom.teacherIds.length}',
                style: GoogleFonts.poppins(fontSize: 36, color: Colors.grey[700]),
              ),
              Row(
                spacing: 10,
                children: [
                  Text('Assignments', style: GoogleFonts.poppins(fontSize: 20, color: Colors.grey[600])),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
                    child: Center(
                      child: Text(
                        widget.classroom.assignmentIds.length.toString(),
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              // Expanded(
              //   child: Container(
              //     padding: const EdgeInsets.all(16.0),
              //     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
              //     child: ListView.separated(
              //       controller: scrollController,
              //       itemCount: classroomAssignments.length,
              //       itemBuilder: (context, assignmentIndex) {
              //         final assignment = classroomAssignments[assignmentIndex];
              //         return FilledButton.tonal(
              //           onPressed: () {},
              //           style: FilledButton.styleFrom(
              //             backgroundColor: Colors.grey[200],
              //             foregroundColor: Colors.black,
              //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              //             padding: const EdgeInsets.all(12.0),
              //           ),
              //           child: Align(
              //             alignment: Alignment.centerLeft,
              //             child: Text(assignment.title, style: GoogleFonts.poppins(fontSize: 14)),
              //           ),
              //         );
              //       },
              //       separatorBuilder: (context, index) => SizedBox(height: 12),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
