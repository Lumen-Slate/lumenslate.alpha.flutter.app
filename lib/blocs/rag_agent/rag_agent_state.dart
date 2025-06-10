part of 'rag_agent_bloc.dart';

@immutable
sealed class RagAgentState {}

final class RagAgentInitial extends RagAgentState {}

final class RagAgentSuccess extends RagAgentState {
  final PagingState<int, ChatMessage> state;

  RagAgentSuccess(this.state);
}

final class RagAgentFailure extends RagAgentState {
  final String message;

  RagAgentFailure(this.message);
}
