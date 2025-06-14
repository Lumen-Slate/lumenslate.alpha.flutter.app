import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
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
  String? _selectedFileUrl;
  String? _selectedFileName;
  String corpusName = 'my_test_corpus';

  @override
  void initState() {
    context.read<RagAgentBloc>().add(FetchRagAgentChatHistory(teacherId: widget.teacherId, pageSize: 20));
    context.read<RagDocumentBloc>().add(ListCorpusContent(corpusName: corpusName));
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
      builder: (context) => AlertDialog(
        title: const Text('Enter PDF File URL'),
        content: TextField(
          controller: urlController,
          decoration: const InputDecoration(
            hintText: 'https://example.com/file.pdf',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final url = urlController.text.trim();
              if (url.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid PDF file URL.')),
                );
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
    );
  }

  void _addDocumentToCorpus() {
    if (_selectedFileUrl != null && _selectedFileName != null) {
      context.read<RagDocumentBloc>().add(
        AddCorpusDocument(
          corpusName: corpusName,
          fileLink: _selectedFileUrl!,
        ),
      );
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
                                    tooltip: 'Attach PDF URL',
                                    onPressed: _showFileUrlDialog,
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
                                child: BlocConsumer<RagDocumentBloc, RagDocumentState>(
                                  listener: (context, state) {
                                    if (state is RagAddCorpusDocumentSuccess) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Document added successfully! Please refresh documents to see it.')),
                                      );
                                    } else if (state is RagDeleteCorpusDocumentSuccess) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Document deleted successfully!')),
                                      );
                                     context.read<RagDocumentBloc>().add(ListCorpusContent(corpusName: corpusName));
                                    } else if (state is RagDocumentFailure) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error: ${state.message}')),
                                      );
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
                                          return ListTile(
                                            leading: const Icon(Icons.insert_drive_file),
                                            title: Text(doc.displayName),
                                            subtitle: Text(
                                              'Uploaded: ${DateTime.parse(doc.createTime).toLocal().toString()}',
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                              tooltip: 'Delete Document',
                                              onPressed: () async {
                                                final confirm = await showDialog<bool>(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text('Delete Document'),
                                                    content: Text('Are you sure you want to delete "${doc.displayName}"?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.of(context).pop(false),
                                                        child: const Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () => Navigator.of(context).pop(true),
                                                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                if (confirm == true) {
                                                  context.read<RagDocumentBloc>().add(
                                                    DeleteCorpusDocument(
                                                      corpusName: corpusName,
                                                      fileDisplayName: doc.displayName,
                                                    ),
                                                  );
                                                }
                                              },
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
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Refresh Documents'),
                                  onPressed: () {
                                    context.read<RagDocumentBloc>().add(ListCorpusContent(corpusName: corpusName));
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
