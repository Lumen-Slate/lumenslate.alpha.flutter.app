import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumen_slate/common/components/base_message/message_barrel.dart';
import 'package:lumen_slate/pages/chat_agent_page/desktop/components/attachment_popup.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:file_picker/file_picker.dart';

import '../../../blocs/chat_agent/chat_agent_bloc.dart';
import '../../../constants/app_constants.dart';
import '../../../models/assignments.dart';
import '../../../models/students.dart';

class ChatAgentPageDesktop extends StatefulWidget {
  /// TODO - Replace with actual teacher ID
  final String teacherId = '0692d515-1621-44ea-85e7-a41335858ee2';

  const ChatAgentPageDesktop({super.key});

  @override
  State<ChatAgentPageDesktop> createState() => _ChatAgentPageDesktopState();
}

class _ChatAgentPageDesktopState extends State<ChatAgentPageDesktop> {
  final TextEditingController _textController = TextEditingController();
  PlatformFile? _selectedFile;
  Student? _selectedStudent;
  Assignment? _selectedAssignment;

  final popupKey = GlobalKey<CustomPopupState>();

  @override
  void initState() {
    context.read<ChatAgentBloc>().add(FetchAgentChatHistory(teacherId: widget.teacherId, pageSize: 20));
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage(BuildContext context) {
    String text = _textController.text.trim();
    String? attachments;

    if (_selectedAssignment != null || _selectedStudent != null) {
      attachments = """
      \n\nHere are the extra attachments attached by user, use them if needed:
      """;
      if (_selectedAssignment != null) {
        attachments += "Assignment ID: ${_selectedAssignment!.id}\n";
      }
      if (_selectedStudent != null) {
        attachments += "Student ID: ${_selectedStudent!.id}\n";
      }
    }

    if (text.isNotEmpty) {
      context.read<ChatAgentBloc>().add(
        CallAgent(teacherId: widget.teacherId, messageString: text, file: _selectedFile, attachments: attachments),
      );
      _textController.clear();
    }

    setState(() {
      _selectedFile = null;
      _selectedStudent = null;
      _selectedAssignment = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: AppConstants.desktopScaleWidth,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Hero(
                    tag: 'agent',
                    child: AutoSizeText(
                      "Lumen Agent",
                      maxLines: 2,
                      minFontSize: 80,
                      style: GoogleFonts.poppins(fontSize: 80, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    spacing: 14,
                    children: [
                      SizedBox(
                        height: 580,
                        child: BlocBuilder<ChatAgentBloc, ChatAgentState>(
                          builder: (context, state) {
                            if (state is ChatAgentStateUpdated) {
                              return PagedListView<int, BaseMessage>(
                                state: state.state,
                                reverse: true,
                                fetchNextPage: () {
                                  context.read<ChatAgentBloc>().add(
                                    FetchAgentChatHistory(teacherId: widget.teacherId, pageSize: 20),
                                  );
                                },
                                builderDelegate: PagedChildBuilderDelegate(
                                  itemBuilder: (context, item, index) => Align(
                                    alignment: (item is ResponseMessage) ? Alignment.centerLeft : Alignment.centerRight,
                                    child: item,
                                  ),
                                  noItemsFoundIndicatorBuilder: (context) => Center(
                                    child: Text(
                                      'Start Your Chat',
                                      style: GoogleFonts.poppins(fontSize: 38, color: Colors.grey[500]),
                                    ),
                                  ),
                                  firstPageErrorIndicatorBuilder: (context) =>
                                      Center(child: Text('Error loading messages')),
                                ),
                              );
                            } else if (state is ChatAgentFailure) {
                              return Center(child: Text(state.message));
                            }
                            return const Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),

                      if (_selectedFile != null)
                        Container(
                          decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 21),
                          child: Row(
                            spacing: 20,
                            children: [
                              const Icon(Icons.file_copy, color: Colors.blue),
                              Expanded(
                                child: Text(
                                  _selectedFile!.name,
                                  style: GoogleFonts.jost(fontSize: 16, color: Colors.blue[800]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.blue),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.blue.shade100,
                                  shape: CircleBorder(),
                                ),
                                tooltip: 'Unselect file',
                                onPressed: () {
                                  setState(() {
                                    _selectedFile = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                      if (_selectedStudent != null)
                        Container(
                          decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 21),
                          child: Row(
                            spacing: 20,
                            children: [
                              const Icon(Icons.school_outlined, color: Colors.green),
                              Expanded(
                                child: Text(
                                  _selectedStudent!.name,
                                  style: GoogleFonts.jost(fontSize: 16, color: Colors.green[800]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.green),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.green.shade100,
                                  shape: CircleBorder(),
                                ),
                                tooltip: 'Unselect student',
                                onPressed: () {
                                  setState(() {
                                    _selectedStudent = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                      if (_selectedAssignment != null)
                        Container(
                          decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 21),
                          child: Row(
                            spacing: 20,
                            children: [
                              const Icon(Icons.assignment_outlined, color: Colors.orange),
                              Expanded(
                                child: Text(
                                  _selectedAssignment!.title,
                                  style: GoogleFonts.jost(fontSize: 16, color: Colors.orange[800]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.orange),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.orange.shade100,
                                  shape: CircleBorder(),
                                ),
                                tooltip: 'Unselect assignment',
                                onPressed: () {
                                  setState(() {
                                    _selectedAssignment = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          spacing: 15,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withValues(alpha: 0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _textController,
                                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: 'Type your message...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  onSubmitted: (_) => _sendMessage(context),
                                ),
                              ),
                            ),
                            AttachmentPopUp(
                              popupKey: popupKey,
                              onFileSelected: (file) {
                                setState(() {
                                  _selectedFile = file;
                                });
                              },
                              onStudentSelected: (student) {
                                setState(() {
                                  _selectedStudent = student;
                                });
                              },
                              onAssignmentSelected: (assignment) {
                                setState(() {
                                  _selectedAssignment = assignment;
                                });
                              },
                            ),

                            BlocBuilder<ChatAgentBloc, ChatAgentState>(
                              builder: (context, state) {
                                return IconButton(
                                  padding: const EdgeInsets.all(20.0),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.green[100],
                                    shape: CircleBorder(),
                                  ),
                                  icon: (state is ChatAgentStateUpdated && state.state.isLoading)
                                      ? Center(
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(color: Colors.green, strokeWidth: 1.7),
                                          ),
                                        )
                                      : const Icon(Icons.send, color: Colors.green),
                                  onPressed: (state is! ChatAgentStateUpdated || (state.state.isLoading))
                                      ? () {}
                                      : () => _sendMessage(context),
                                );
                              },
                            ),
                          ],
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
