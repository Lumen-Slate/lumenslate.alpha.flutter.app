import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumen_slate/serializers/agent_serializers/agent_response.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:file_picker/file_picker.dart';

import '../../../blocs/chat_agent/chat_agent_bloc.dart';
import 'components/message_tile.dart';

class ChatAgentPageDesktop extends StatefulWidget {
  final String teacherId = '0692d515-1621-44ea-85e7-a41335858ee2';

  const ChatAgentPageDesktop({super.key});

  @override
  State<ChatAgentPageDesktop> createState() => _ChatAgentPageDesktopState();
}

class _ChatAgentPageDesktopState extends State<ChatAgentPageDesktop> {
  final TextEditingController _textController = TextEditingController();
  PlatformFile? _selectedFile;

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
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatAgentBloc>().add(CallAgent(teacherId: widget.teacherId, messageString: text));
      _textController.clear();
    }
  }

  Future<void> _pickSupportedFile() async {
    final allowedExtensions = [
      // Images
      'jpg', 'jpeg', 'png', 'webp',
      // Audio
      'wav', 'mp3', 'aiff', 'aac', 'ogg', 'flac',
      // Text
      'pdf',
    ];
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final ext = file.extension?.toLowerCase();
      if (!allowedExtensions.contains(ext)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unsupported file type selected.')),
        );
        return;
      }
      setState(() {
        _selectedFile = file;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected: ${file.name}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: 1920,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Hero(tag: 'agent',
                  child: AutoSizeText("Agent", maxLines: 2, minFontSize: 80, style: GoogleFonts.poppins(fontSize: 80, color: Colors.black))),
                ),
                const SizedBox(height: 50),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: [
                      // Paginated Chat Messages List
                      SizedBox(
                        height: 580,
                        child: BlocBuilder<ChatAgentBloc, ChatAgentState>(
                          builder: (context, state) {
                            if (state is ChatAgentSuccess) {
                              return PagedListView<int, AgentResponse>(
                                state: state.state,
                                reverse: true,
                                fetchNextPage: () {
                                  context.read<ChatAgentBloc>().add(
                                    FetchAgentChatHistory(teacherId: widget.teacherId, pageSize: 20),
                                  );
                                },
                                builderDelegate: PagedChildBuilderDelegate(
                                  itemBuilder: (context, item, index) => MessageTile(message: item),
                                  noItemsFoundIndicatorBuilder: (context) => Center(child: Text('No messages')),
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
                      // Show selected file and unselect button if a file is selected
                      if (_selectedFile != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                          child: Row(
                            children: [
                              const Icon(Icons.attach_file, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedFile!.name,
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 20),
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
                      // Message Input
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
                                      color: Colors.grey.withValues(alpha: 0.9),
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
                            IconButton(
                              padding: const EdgeInsets.all(20.0),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.blue[100],
                                shape: CircleBorder(),
                              ),
                              icon: const Icon(Icons.attach_file),
                              tooltip: 'Attach file',
                              onPressed: _pickSupportedFile,
                            ),
                            IconButton(
                              padding: const EdgeInsets.all(20.0),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.green[100],
                                shape: CircleBorder(),
                              ),
                              icon: const Icon(Icons.send),
                              onPressed: () => _sendMessage(context),
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
