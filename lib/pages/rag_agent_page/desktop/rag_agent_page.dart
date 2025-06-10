import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../blocs/rag_agent/rag_agent_bloc.dart';
import '../../../blocs/rag_document/rag_document_bloc.dart';
import '../../../models/chat_message.dart';
import '../../chat_agent_page/desktop/components/message_tile.dart';

class RagAgentPageDesktop extends StatefulWidget {
  final String teacherId = '0692d515-1621-44ea-85e7-a41335858ee2';

  const RagAgentPageDesktop({super.key});

  @override
  State<RagAgentPageDesktop> createState() => _RagAgentPageDesktopState();
}

class _RagAgentPageDesktopState extends State<RagAgentPageDesktop> {
  final TextEditingController _textController = TextEditingController();
  PlatformFile? _selectedFile;

  @override
  void initState() {
    context.read<RagAgentBloc>().add(FetchRagAgentChatHistory(teacherId: widget.teacherId, pageSize: 20));
    context.read<RagDocumentBloc>().add(FetchRagDocuments(teacherId: widget.teacherId));
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
      context.read<RagAgentBloc>().add(CallRagAgent(teacherId: widget.teacherId, messageString: text));
      _textController.clear();
    }
  }

  Future<void> _pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.extension?.toLowerCase() != 'pdf') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Only PDF files are allowed.')),
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
                  child: Hero(
                    tag: 'rag_agent',
                    child: AutoSizeText(
                      "RAG Agent",
                      maxLines: 2,
                      minFontSize: 80,
                      style: GoogleFonts.poppins(fontSize: 80, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  spacing: 40,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          children: [
                            // Paginated Chat Messages List
                            SizedBox(
                              height: 580,
                              child: BlocBuilder<RagAgentBloc, RagAgentState>(
                                builder: (context, state) {
                                  if (state is RagAgentSuccess) {
                                    return PagedListView<int, ChatMessage>(
                                      state: state.state,
                                      reverse: true,
                                      fetchNextPage: () {
                                        context.read<RagAgentBloc>().add(
                                          FetchRagAgentChatHistory(teacherId: widget.teacherId, pageSize: 20),
                                        );
                                      },
                                      builderDelegate: PagedChildBuilderDelegate(
                                        itemBuilder: (context, item, index) => MessageTile(message: item),
                                        noItemsFoundIndicatorBuilder: (context) => Center(child: Text('No messages')),
                                        firstPageErrorIndicatorBuilder: (context) =>
                                            Center(child: Text('Error loading messages')),
                                      ),
                                    );
                                  } else if (state is RagAgentFailure) {
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
                                    const Icon(Icons.picture_as_pdf, color: Colors.red),
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
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _textController,
                                      decoration: const InputDecoration(
                                        hintText: 'Type your message...',
                                        border: OutlineInputBorder(),
                                      ),
                                      onSubmitted: (_) => _sendMessage(context),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.attach_file),
                                    tooltip: 'Attach PDF',
                                    onPressed: _pickPdfFile,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: () => _sendMessage(context),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(30)),
                        child: SizedBox(
                          height: 650,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                "RAG Documents",
                                maxLines: 2,
                                minFontSize: 40,
                                style: GoogleFonts.poppins(fontSize: 40, color: Colors.black),
                              ),
                              const SizedBox(height: 20),
                              AutoSizeText(
                                "This is a RAG Agent that can answer questions based on the provided context.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(fontSize: 20, color: Colors.black54),
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: BlocBuilder<RagDocumentBloc, RagDocumentState>(
                                  builder: (context, state) {
                                    if (state is RagDocumentLoading) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (state is RagDocumentFailure) {
                                      return Center(child: Text(state.message));
                                    } else if (state is RagDocumentSuccess) {
                                      if (state.documents.isEmpty) {
                                        return const Center(child: Text('No documents found.'));
                                      }
                                      return ListView.separated(
                                        itemCount: state.documents.length,
                                        separatorBuilder: (_, __) => const Divider(),
                                        itemBuilder: (context, idx) {
                                          final doc = state.documents[idx];
                                          return ListTile(
                                            leading: const Icon(Icons.insert_drive_file),
                                            title: Text(doc.fileName),
                                            subtitle: Text(
                                              'Uploaded: ${doc.uploadedAt.toLocal()}',
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
