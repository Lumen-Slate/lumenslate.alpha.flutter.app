part of 'rag_agent_bloc.dart';

@immutable
sealed class RagAgentEvent {}

final class CallRagAgent extends RagAgentEvent {
  final String teacherId;
  final String messageString;
  final String? file;

  CallRagAgent({
    required this.teacherId,
    required this.messageString,
    this.file,
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
