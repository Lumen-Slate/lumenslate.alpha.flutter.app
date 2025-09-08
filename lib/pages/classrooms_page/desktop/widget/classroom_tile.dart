import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:lumen_slate/models/classroom.dart';

import '../../../../blocs/classroom/classroom_bloc.dart';

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
        if (_isOverflowing &&
            _toolTipController.value == TooltipStatus.isHidden) {
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
          context.go(
            '/teacher-dashboard/classrooms/${widget.classroom.id}/students',
          );
        },
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          padding: const EdgeInsets.all(0),
          elevation: 3,
        ),
        child: Container(
          width: 640,
          constraints: const BoxConstraints(minHeight: 900),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: Colors.grey[300]!, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 32.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, size) {
                      TextSpan span = TextSpan(
                        text: widget.classroom.name,
                        style: GoogleFonts.poppins(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[900],
                        ),
                      );
                      TextPainter tp = TextPainter(
                        maxLines: 1,
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
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10.0,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              widget.classroom.name,
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          child: Text(
                            widget.classroom.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[900],
                            ),
                          ),
                        );
                      } else {
                        return Text(
                          widget.classroom.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[900],
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.blueGrey[400], size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'Teachers: ${widget.classroom.teacherIds.length}',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          color: Colors.blueGrey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Edit Classroom',
                        onPressed: () async {
                          final nameController = TextEditingController(
                            text: widget.classroom.name,
                          );
                          final creditsController = TextEditingController(
                            text: widget.classroom.credits.toString(),
                          );
                          final tagsController = TextEditingController(
                            text: widget.classroom.tags?.join(", "),
                          );
                          final subjectController = TextEditingController(
                            text: widget.classroom.classroomSubject ?? '',
                          );
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Update Classroom'),
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
                                      final updatedClassroom = Classroom(
                                        id: widget.classroom.id,
                                        name: nameController.text,
                                        teacherIds: widget.classroom.teacherIds,
                                        assignmentIds:
                                            widget.classroom.assignmentIds,
                                        credits:
                                            int.tryParse(
                                              creditsController.text,
                                            ) ??
                                            widget.classroom.credits,
                                        tags: tagsController.text
                                            .split(',')
                                            .map((e) => e.trim())
                                            .where((e) => e.isNotEmpty)
                                            .toList(),
                                        classroomCode:
                                            widget.classroom.classroomCode,
                                        classroomSubject: subjectController.text,
                                      );
                                      BlocProvider.of<ClassroomBloc>(context).add(
                                        UpdateClassroom(
                                          id: widget.classroom.id,
                                          classroom: updatedClassroom,
                                          teacherId:
                                              widget.classroom.teacherIds.first,
                                        ),
                                      );
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Classroom updated successfully',
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: const Text('Update'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete Classroom',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete Classroom'),
                                content: const Text(
                                  'Are you sure you want to delete this classroom?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      BlocProvider.of<ClassroomBloc>(
                                        context,
                                      ).add(DeleteClassroom(widget.classroom.id));
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Classroom deleted successfully',
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.assignment, color: Colors.green[400], size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Assignments: ',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.green[200]!, width: 1),
                        ),
                        child: Center(
                          child: Text(
                            widget.classroom.assignmentIds.length.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.green[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.classroom.classroomSubject != null &&
                      widget.classroom.classroomSubject!.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(Icons.book, color: Colors.deepPurple[400], size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Subject:',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.deepPurple[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            widget.classroom.classroomSubject!,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.deepPurple[900],
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (widget.classroom.classroomCode != null &&
                      widget.classroom.classroomCode!.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(Icons.code, color: Colors.orange[400], size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Classroom Code:',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.orange[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            widget.classroom.classroomCode!,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.orange[900],
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
