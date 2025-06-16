part of 'chat_agent_bloc.dart';

@immutable
sealed class ChatAgentEvent {}

final class CallAgent extends ChatAgentEvent {
  final String teacherId;
  final String message;

  CallAgent({
    required this.teacherId,
    required this.message,
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
