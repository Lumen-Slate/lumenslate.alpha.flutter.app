part of 'chat_agent_bloc.dart';

@immutable
sealed class ChatAgentEvent {}

final class CallAgent extends ChatAgentEvent {
  final String teacherId;
  final String messageString;
  final PlatformFile? file;
  final String? attachments;

  CallAgent({
    required this.teacherId,
    required this.messageString,
    this.file,
    this.attachments,
  });
}

final class FetchAgentChatHistory extends ChatAgentEvent {
  final String teacherId;
  final int pageSize;

  FetchAgentChatHistory({
    required this.teacherId,
    this.pageSize = 20,
  });
}
