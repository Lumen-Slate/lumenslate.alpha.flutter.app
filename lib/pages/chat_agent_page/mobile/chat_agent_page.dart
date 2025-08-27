import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:lumen_slate/common/components/base_message/base_message.dart';

import '../../../blocs/chat_agent/chat_agent_bloc.dart';
import '../../../models/assignments.dart';
import '../../../models/students.dart';
import 'components/attachment_bottom_sheet.dart';

class ChatAgentPageMobile extends StatefulWidget {
  /// TODO - Replace with actual teacher ID
  final String teacherId = '0692d515-1621-44ea-85e7-a41335858ee2';

  const ChatAgentPageMobile({super.key});

  @override
  State<ChatAgentPageMobile> createState() => _ChatAgentPageMobileState();
}

class _ChatAgentPageMobileState extends State<ChatAgentPageMobile> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PlatformFile? _selectedFile;
  Student? _selectedStudent;
  Assignment? _selectedAssignment;

  @override
  void initState() {
    super.initState();
    context.read<ChatAgentBloc>().add(
      FetchAgentChatHistory(teacherId: widget.teacherId, pageSize: 20),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
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
        CallAgent(
          teacherId: widget.teacherId,
          messageString: text,
          file: _selectedFile,
          attachments: attachments,
        ),
      );
      _textController.clear();
    }

    setState(() {
      _selectedFile = null;
      _selectedStudent = null;
      _selectedAssignment = null;
    });
  }

  void _showAttachmentBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AttachmentBottomSheet(
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
    );
  }

  void _clearAttachment(String type) {
    setState(() {
      switch (type) {
        case 'file':
          _selectedFile = null;
          break;
        case 'student':
          _selectedStudent = null;
          break;
        case 'assignment':
          _selectedAssignment = null;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (result, object) {
        // Handle navigation back
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Lumen Agent",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Column(
          children: [
            // Chat messages area
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<ChatAgentBloc, ChatAgentState>(
                  builder: (context, state) {
                    if (state is ChatAgentStateUpdated) {
                      return PagedListView<int, BaseMessage>(
                        scrollController: _scrollController,
                        state: state.state,
                        fetchNextPage: () {
                          // Implement pagination if needed
                        },
                        builderDelegate:
                            PagedChildBuilderDelegate<BaseMessage>(
                              itemBuilder: (context, item, index) => item,
                              noItemsFoundIndicatorBuilder: (context) => Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Start a conversation with Lumen Agent',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              firstPageErrorIndicatorBuilder: (context) =>
                                  Center(
                                    child: Text(
                                      'Error loading messages',
                                      style: GoogleFonts.poppins(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                            ),
                      );
                    } else if (state is ChatAgentFailure) {
                      return Center(
                        child: Text(
                          state.message,
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),

            // Attachments preview
            if (_selectedFile != null ||
                _selectedStudent != null ||
                _selectedAssignment != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedFile != null)
                      _buildAttachmentChip(
                        icon: Icons.file_copy,
                        label: _selectedFile!.name,
                        color: Colors.blue,
                        onRemove: () => _clearAttachment('file'),
                      ),
                    if (_selectedStudent != null)
                      _buildAttachmentChip(
                        icon: Icons.school_outlined,
                        label: _selectedStudent!.name,
                        color: Colors.green,
                        onRemove: () => _clearAttachment('student'),
                      ),
                    if (_selectedAssignment != null)
                      _buildAttachmentChip(
                        icon: Icons.assignment,
                        label: _selectedAssignment!.title,
                        color: Colors.orange,
                        onRemove: () => _clearAttachment('assignment'),
                      ),
                  ],
                ),
              ),

            // Input area
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Attachment button
                    IconButton(
                      onPressed: _showAttachmentBottomSheet,
                      icon: const Icon(Icons.attach_file),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Text input
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Send button
                    BlocBuilder<ChatAgentBloc, ChatAgentState>(
                      builder: (context, state) {
                        final isLoading =
                            state is ChatAgentStateUpdated &&
                            state.state.isLoading;
                        return IconButton(
                          onPressed: isLoading
                              ? null
                              : () => _sendMessage(context),
                          icon: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.send),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(12),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Chip(
        avatar: Icon(icon, size: 16, color: color),
        label: Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        backgroundColor: color.withValues(alpha: 0.1),
        deleteIconColor: color,
      ),
    );
  }
}
