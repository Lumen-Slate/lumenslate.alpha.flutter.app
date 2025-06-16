import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../blocs/chat_agent/chat_agent_bloc.dart';
import '../../../models/chat_message.dart';
import 'components/message_tile.dart';

class ChatAgentPageDesktop extends StatefulWidget {
  final String teacherId = '0692d515-1621-44ea-85e7-a41335858ee2';

  const ChatAgentPageDesktop({super.key});

  @override
  State<ChatAgentPageDesktop> createState() => _ChatAgentPageDesktopState();
}

class _ChatAgentPageDesktopState extends State<ChatAgentPageDesktop> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
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
                  child: AutoSizeText("Agent", maxLines: 2, minFontSize: 80, style: GoogleFonts.poppins(fontSize: 80))),
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
                              return PagedListView<int, ChatMessage>(
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
                            IconButton(icon: const Icon(Icons.send), onPressed: () => _sendMessage(context)),
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


