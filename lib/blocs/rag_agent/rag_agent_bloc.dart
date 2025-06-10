import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../models/chat_message.dart';
import '../../repositories/ai/rag_agent_repository.dart';

part 'rag_agent_event.dart';
part 'rag_agent_state.dart';

class RagAgentBloc extends Bloc<RagAgentEvent, RagAgentState> {
  final RagAgentRepository repository;

  RagAgentBloc({required this.repository}) : super(RagAgentInitial()) {
    on<CallRagAgent>((event, emit) async {
      PagingState<int, ChatMessage> pagingState;
      if (state is RagAgentSuccess) {
        pagingState = (state as RagAgentSuccess).state;
      } else {
        pagingState = PagingState<int, ChatMessage>();
      }

      final userMessage = ChatMessage(
        id: UniqueKey().toString(),
        message: event.messageString,
        data: null,
        agentName: 'user',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final List<List<ChatMessage>> updatedPages = List.from(pagingState.pages ?? []);
      if (updatedPages.isNotEmpty) {
        updatedPages[updatedPages.length - 1] = [
          userMessage,
          ...updatedPages.last,
        ];
      } else {
        updatedPages.add([userMessage]);
      }

      emit(RagAgentSuccess(pagingState.copyWith(pages: updatedPages, isLoading: true, error: null)));

      try {
        final response = await repository.callRagAgent(
          teacherId: event.teacherId,
          message: event.messageString,
        );
        if (response != null && response.statusCode == 200) {
          final ChatMessage agentMessage = ChatMessage.fromJson(response.data);

          final List<List<ChatMessage>> replyPages = List.from(updatedPages);
          if (replyPages.isNotEmpty) {
            replyPages[replyPages.length - 1] = [
              agentMessage,
              ...replyPages.last,
            ];
          } else {
            replyPages.add([agentMessage]);
          }

          emit(RagAgentSuccess(pagingState.copyWith(pages: replyPages, isLoading: false)));
        } else {
          emit(RagAgentFailure('Failed to get agent response'));
        }
      } catch (error) {
        emit(RagAgentFailure(error.toString()));
      }
    });

    on<FetchRagAgentChatHistory>((event, emit) async {
      PagingState<int, ChatMessage> pagingState;
      if (state is RagAgentSuccess) {
        pagingState = (state as RagAgentSuccess).state;
      } else {
        pagingState = PagingState<int, ChatMessage>();
      }

      if (pagingState.isLoading || !pagingState.hasNextPage) return;

      emit(RagAgentSuccess(pagingState.copyWith(isLoading: true, error: null)));

      try {
        final int nextOffset = (pagingState.keys?.last ?? 0) + (pagingState.pages?.lastOrNull?.length ?? 0);
        final response = await repository.fetchRagChatHistory(
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
          emit(RagAgentSuccess(newPagingState));
        } else {
          emit(RagAgentFailure('Failed to fetch chat history'));
        }
      } catch (error) {
        emit(RagAgentFailure(error.toString()));
      }
    });
  }
}
