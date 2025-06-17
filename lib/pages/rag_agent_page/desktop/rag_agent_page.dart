import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumen_slate/serializers/rag_agent_serializers/reg_agent_response.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../blocs/rag_agent/rag_agent_bloc.dart';
import '../../../blocs/rag_document/rag_document_bloc.dart';
import 'components/rag_message_tile.dart';

class RagAgentPageDesktop extends StatefulWidget {
  /// TODO: Replace with actual teacher ID
  final String teacherId = '0692d515-1621-44ea-85e7-a41335858ee2';

  /// TODO : Hardcoded data
  final String corpusName = 'my_test_corpus';

  const RagAgentPageDesktop({super.key});

  @override
  State<RagAgentPageDesktop> createState() => _RagAgentPageDesktopState();
}

class _RagAgentPageDesktopState extends State<RagAgentPageDesktop> {
  final TextEditingController _textController = TextEditingController();
  String? _selectedFileUrl;
  String? _selectedFileName;

  @override
  void initState() {
    context.read<RagAgentBloc>().add(FetchRagAgentChatHistory(teacherId: widget.teacherId, pageSize: 20));
    context.read<RagDocumentBloc>().add(ListCorpusContent(corpusName: widget.corpusName));
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

  Future<void> _showFileUrlDialog() async {
    final urlController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          width: 900,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter Google Drive PDF File URL',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: urlController,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                decoration: const InputDecoration(
                  hintText: 'https://example.com/file.pdf',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      final url = urlController.text.trim();
                      if (url.isEmpty) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Please enter a valid PDF file URL.')));
                        return;
                      }
                      setState(() {
                        _selectedFileUrl = url;
                        _selectedFileName = url.split('/').last;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Select'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addDocumentToCorpus() {
    if (_selectedFileUrl != null && _selectedFileName != null) {
      context.read<RagDocumentBloc>().add(AddCorpusDocument(corpusName: widget.corpusName, fileLink: _selectedFileUrl!));
      setState(() {
        _selectedFileUrl = null;
        _selectedFileName = null;
      });
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
                                    return PagedListView<int, RagAgentResponse>(
                                      state: state.state,
                                      reverse: true,
                                      fetchNextPage: () {
                                        context.read<RagAgentBloc>().add(
                                          FetchRagAgentChatHistory(teacherId: widget.teacherId, pageSize: 20),
                                        );
                                      },
                                      builderDelegate: PagedChildBuilderDelegate(
                                        itemBuilder: (context, item, index) => RagMessageTile(message: item),
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
                                  } else if (state is RagAgentFailure) {
                                    return Center(child: Text(state.message));
                                  }
                                  return const Center(child: CircularProgressIndicator());
                                },
                              ),
                            ),
                            // Show selected file url and unselect/add button if a file url is selected
                            if (_selectedFileUrl != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.link, color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _selectedFileName ?? _selectedFileUrl!,
                                        style: const TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 20),
                                      tooltip: 'Unselect file',
                                      onPressed: () {
                                        setState(() {
                                          _selectedFileUrl = null;
                                          _selectedFileName = null;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.cloud_upload),
                                      tooltip: 'Add to Corpus',
                                      onPressed: _addDocumentToCorpus,
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
                                  IconButton(
                                    padding: const EdgeInsets.all(20.0),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.blue[100],
                                      shape: const CircleBorder(),
                                    ),
                                    icon: const Icon(Icons.attach_file, color: Colors.blue),
                                    tooltip: 'Attach PDF URL',
                                    onPressed: _showFileUrlDialog,
                                  ),
                                  IconButton(
                                    padding: const EdgeInsets.all(20.0),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.green[100],
                                      shape: const CircleBorder(),
                                    ),
                                    icon: const Icon(Icons.send, color: Colors.green),
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
                                child: BlocConsumer<RagDocumentBloc, RagDocumentState>(
                                  listener: (context, state) {
                                    if (state is RagAddCorpusDocumentSuccess) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Document added successfully! Please refresh documents to see it.',
                                          ),
                                        ),
                                      );
                                    } else if (state is RagDeleteCorpusDocumentSuccess) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(const SnackBar(content: Text('Document deleted successfully!')));
                                      context.read<RagDocumentBloc>().add(ListCorpusContent(corpusName: widget.corpusName));
                                    } else if (state is RagDocumentFailure) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is RagDocumentFailure) {
                                      return Center(child: Text(state.message));
                                    } else if (state is RagListCorpusContentSuccess) {
                                      final docs = state.response?.files ?? [];
                                      if (docs.isEmpty) {
                                        return const Center(child: Text('No documents found.'));
                                      }
                                      return ListView.separated(
                                        itemCount: docs.length,
                                        separatorBuilder: (_, __) => const Divider(),
                                        itemBuilder: (context, idx) {
                                          final doc = docs[idx];
                                          return Container(
                                            padding: const EdgeInsets.all(12.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withValues(alpha: 0.2),
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.insert_drive_file, color: Colors.blue),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(doc.displayName, style: const TextStyle(fontSize: 16)),
                                                      Text(
                                                        'Uploaded: ${DateTime.parse(doc.createTime).toLocal().toString()}',
                                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  padding: const EdgeInsets.all(14.0),
                                                  style: IconButton.styleFrom(
                                                    backgroundColor: Colors.red[100],
                                                    shape: const CircleBorder(),
                                                  ),
                                                  icon: const Icon(Icons.delete, color: Colors.red),
                                                  tooltip: 'Delete Document',
                                                  onPressed: () async {
                                                    final confirm = await showDialog<bool>(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: const Text('Delete Document'),
                                                        content: Text(
                                                          'Are you sure you want to delete "${doc.displayName}"?',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.of(context).pop(false),
                                                            child: const Text('Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () => Navigator.of(context).pop(true),
                                                            child: const Text(
                                                              'Delete',
                                                              style: TextStyle(color: Colors.red),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                    if (confirm == true) {
                                                      context.read<RagDocumentBloc>().add(
                                                        DeleteCorpusDocument(
                                                          corpusName: widget.corpusName,
                                                          fileDisplayName: doc.displayName,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              ),
                              // Add button to refresh the document list
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: FilledButton.tonal(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.blue[100],
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  ),
                                  onPressed: () {
                                    context.read<RagDocumentBloc>().add(ListCorpusContent(corpusName: widget.corpusName));
                                  },
                                  child: Row(
                                    spacing: 10,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.refresh, color: Colors.blue),
                                      Text(
                                        'Refresh Documents',
                                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.blue),
                                      ),
                                    ],
                                  ),
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
