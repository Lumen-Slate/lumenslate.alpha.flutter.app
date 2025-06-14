part of 'rag_agent_bloc.dart';

@immutable
sealed class RagAgentState {}

final class RagAgentInitial extends RagAgentState {}

final class RagAgentStateUpdate extends RagAgentState {
  final PagingState<int, RagAgentResponse> state;

  RagAgentStateUpdate(this.state);
}

final class RagAgentFailure extends RagAgentState {
  final String message;

  RagAgentFailure(this.message);
}
