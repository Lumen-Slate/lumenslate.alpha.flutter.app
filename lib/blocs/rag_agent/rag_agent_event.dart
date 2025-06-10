part of 'rag_agent_bloc.dart';

@immutable
sealed class RagAgentEvent {}

final class CallRagAgent extends RagAgentEvent {
  final String teacherId;
  final String messageString;

  CallRagAgent({
    required this.teacherId,
    required this.messageString,
  });
}

final class FetchRagAgentChatHistory extends RagAgentEvent {
  final String teacherId;
  final int pageSize;

  FetchRagAgentChatHistory({
    required this.teacherId,
    this.pageSize = 20,
  });
}
