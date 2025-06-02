import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassroomCardMobile extends StatelessWidget {
  final dynamic classroom;
  final List<String> teacherNames;
  final List<dynamic> classroomAssignments;
  final int index;

  const ClassroomCardMobile({
    super.key,
    required this.classroom,
    required this.teacherNames,
    required this.classroomAssignments,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/classroom/${classroom.id}');
        /// TODO: Implement navigation to classroom details
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.primaries[index % Colors.primaries.length][400],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classroom.subject,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    classroom.id,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  if (teacherNames.isNotEmpty) const SizedBox(height: 4),
                  if (teacherNames.isNotEmpty)
                    Text(
                      "Teachers: ${teacherNames.join(", ")}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Assignments",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (classroomAssignments.isNotEmpty)
                    SizedBox(
                      height: 150,
                      child: Scrollbar(
                        controller: scrollController,
                        thumbVisibility: true,
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: classroomAssignments.length,
                          itemBuilder: (context, aIndex) {
                            final assignment = classroomAssignments[aIndex];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    assignment.title,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    assignment.body,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Deadline: ${assignment.dueDate.toLocal().toString().split(' ')[0]}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.red[400],
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  else
                    Text(
                      "No assignments",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(Icons.show_chart, size: 20),
                      SizedBox(width: 10),
                      Icon(Icons.folder_open, size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
