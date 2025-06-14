part of 'chat_agent_bloc.dart';

@immutable
sealed class ChatAgentState {}

final class ChatAgentInitial extends ChatAgentState {}

final class ChatAgentStateUpdate extends ChatAgentState {
  final PagingState<int, AgentResponse> state;

  ChatAgentStateUpdate(this.state);
}

final class ChatAgentFailure extends ChatAgentState {
  final String message;

  ChatAgentFailure(this.message);
}
