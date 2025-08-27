part of 'chat_agent_bloc.dart';

@immutable
sealed class ChatAgentState {}

final class ChatAgentInitial extends ChatAgentState {}

final class ChatAgentStateUpdated extends ChatAgentState {
  final PagingState<int, BaseMessage> state;

  ChatAgentStateUpdated(this.state);
}

final class ChatAgentFailure extends ChatAgentState {
  final String message;

  ChatAgentFailure(this.message);
}
