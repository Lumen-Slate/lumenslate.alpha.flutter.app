import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/rag_agent/rag_agent_bloc.dart';
import '../../../blocs/rag_document/rag_document_bloc.dart';
import '../../../serializers/rag_agent_serializers/reg_agent_response.dart';
import 'components/rag_message_tile_mobile.dart';
import 'components/document_bottom_sheet.dart';

class RagAgentPageMobile extends StatefulWidget {
  /// TODO: Replace with actual teacher ID
  final String teacherId = '0692d515-1621-44ea-85e7-a41335858ee2';

  /// TODO : Hardcoded data
  final String corpusName = 'my_test_corpus';

  const RagAgentPageMobile({super.key});

  @override
  State<RagAgentPageMobile> createState() => _RagAgentPageMobileState();
}

class _RagAgentPageMobileState extends State<RagAgentPageMobile> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<RagAgentBloc>().add(
      FetchRagAgentChatHistory(teacherId: widget.teacherId, pageSize: 20),
    );
    context.read<RagDocumentBloc>().add(
      ListCorpusContent(corpusName: widget.corpusName),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(BuildContext context) {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.read<RagAgentBloc>().add(
        CallRagAgent(teacherId: widget.teacherId, messageString: text),
      );
      _textController.clear();
    }
  }

  void _showDocumentBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DocumentBottomSheet(
        corpusName: widget.corpusName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.go('/teacher-dashboard');
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.go('/teacher-dashboard'),
          ),
          title: Text(
            'Knowledge Based Generation',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.folder_open, color: Colors.blue),
              onPressed: _showDocumentBottomSheet,
              tooltip: 'Manage Documents',
            ),
          ],
        ),
        body: Column(
          children: [
            // Chat Messages
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: BlocBuilder<RagAgentBloc, RagAgentState>(
                  builder: (context, state) {
                    if (state is RagAgentStateUpdate) {
                      return PagedListView<int, RagAgentResponse>(
                        state: state.state,
                        reverse: true,
                        scrollController: _scrollController,
                        fetchNextPage: () {
                          context.read<RagAgentBloc>().add(
                            FetchRagAgentChatHistory(
                              teacherId: widget.teacherId,
                              pageSize: 20,
                            ),
                          );
                        },
                        builderDelegate: PagedChildBuilderDelegate(
                          itemBuilder: (context, item, index) => 
                              RagMessageTileMobile(message: item),
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
                                  'Start Your Chat',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Ask questions based on your documents',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          firstPageErrorIndicatorBuilder: (context) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error loading messages',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (state is RagAgentFailure) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
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
            // Message Input Area
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Attachment Button
                    IconButton(
                      onPressed: _showDocumentBottomSheet,
                      icon: const Icon(Icons.attach_file, color: Colors.blue),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue.withValues(alpha: 0.1),
                        shape: const CircleBorder(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Text Input
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _textController,
                          style: GoogleFonts.poppins(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Ask about your documents...',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey[500],
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(context),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Send Button
                    BlocBuilder<RagAgentBloc, RagAgentState>(
                      builder: (context, state) {
                        final isLoading = state is RagAgentStateUpdate &&
                            state.state.isLoading;
                        
                        return IconButton(
                          onPressed: isLoading ? null : () => _sendMessage(context),
                          icon: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.send, color: Colors.white),
                          style: IconButton.styleFrom(
                            backgroundColor: isLoading 
                                ? Colors.grey 
                                : Colors.green,
                            shape: const CircleBorder(),
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
}
