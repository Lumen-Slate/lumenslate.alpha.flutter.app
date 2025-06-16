import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../models/chat_message.dart';
import '../../repositories/ai/agent_repository.dart';

part 'chat_agent_event.dart';
part 'chat_agent_state.dart';

class ChatAgentBloc extends Bloc<ChatAgentEvent, ChatAgentState> {
  final AgentRepository repository;

  ChatAgentBloc({required this.repository}) : super(ChatAgentInitial()) {
    on<CallAgent>((event, emit) async {
      PagingState<int, ChatMessage> pagingState;
      if (state is ChatAgentSuccess) {
        pagingState = (state as ChatAgentSuccess).state;
      } else {
        pagingState = PagingState<int, ChatMessage>(
          pages: [],
          keys: [],
          isLoading: false,
          hasNextPage: true,
        );
      }

      emit(ChatAgentSuccess(
        pagingState.copyWith(isLoading: true, error: null),
      ));

      try {
        final response = await repository.callAgent(
          teacherId: event.teacherId,
          message: event.message,
        );
        if (response != null && response.statusCode == 200) {
          final ChatMessage newMessage = ChatMessage.fromJson(response.data);

          // Append the new message to the last page or create a new page if none exist
          final List<List<ChatMessage>> updatedPages = List.from(pagingState.pages ?? []);
          if (updatedPages.isNotEmpty) {
            updatedPages[updatedPages.length - 1] = [
              ...updatedPages.last,
              newMessage,
            ];
          } else {
            updatedPages.add([newMessage]);
          }

          emit(ChatAgentSuccess(
            pagingState.copyWith(
              pages: updatedPages,
              isLoading: false,
            ),
          ));
        } else {
          emit(ChatAgentFailure('Failed to get agent response'));
        }
      } catch (error) {
        emit(ChatAgentFailure(error.toString()));
      }
    });

    on<FetchAgentChatHistory>((event, emit) async {
      PagingState<int, ChatMessage> pagingState;
      if (state is ChatAgentSuccess) {
        pagingState = (state as ChatAgentSuccess).state;
      } else {
        pagingState = PagingState<int, ChatMessage>(
          pages: [],
          keys: [],
          isLoading: false,
          hasNextPage: true,
        );
      }

      if (pagingState.isLoading || !pagingState.hasNextPage) return;

      emit(ChatAgentSuccess(
        pagingState.copyWith(isLoading: true, error: null),
      ));

      try {
        final int nextOffset = (pagingState.keys?.last ?? 0) + (pagingState.pages?.lastOrNull?.length ?? 0);
        final response = await repository.fetchChatHistory(
          teacherId: event.teacherId,
          limit: event.pageSize,
          offset: nextOffset,
        );
        if (response != null && response.statusCode == 200) {
          final List data = response.data;
          final messages = data.map((e) => ChatMessage.fromJson(e)).toList().cast<ChatMessage>();
          final isLastPage = messages.length < event.pageSize;

          final newPagingState = pagingState.copyWith(
            pages: [...?pagingState.pages, messages],
            keys: [...pagingState.keys ?? [], nextOffset],
            hasNextPage: !isLastPage,
            isLoading: false,
          );
          emit(ChatAgentSuccess(newPagingState));
        } else {
          emit(ChatAgentFailure('Failed to fetch chat history'));
        }
      } catch (error) {
        emit(ChatAgentFailure(error.toString()));
      }
    });
  }
}