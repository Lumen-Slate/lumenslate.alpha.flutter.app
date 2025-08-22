import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lumen_slate/serializers/rag_agent_serializers/reg_agent_response.dart';
import '../../repositories/ai/rag_agent_repository.dart';
import '../../serializers/rag_agent_serializers/rag_agent_payload.dart';

part 'rag_agent_event.dart';

part 'rag_agent_state.dart';

class RagAgentBloc extends Bloc<RagAgentEvent, RagAgentState> {
  final RagAgentRepository repository;

  RagAgentBloc({required this.repository}) : super(RagAgentInitial()) {
    on<CallRagAgent>((event, emit) async {
      PagingState<int, RagAgentResponse> pagingState;
      if (state is RagAgentStateUpdate) {
        pagingState = (state as RagAgentStateUpdate).state;
      } else {
        pagingState = PagingState<int, RagAgentResponse>();
      }

      final userMessage = RagAgentResponse(
        message: event.messageString,
        data: null,
        agentName: 'user',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        teacherId: event.teacherId,
        sessionId: '',
        responseTime: 0,
        role: 'user',
        feedback: 'neutral',
      );

      final List<List<RagAgentResponse>> updatedPages = List.from(
        pagingState.pages ?? [],
      );
      if (updatedPages.isNotEmpty) {
        updatedPages[updatedPages.length - 1] = [
          userMessage,
          ...updatedPages.last,
        ];
      } else {
        updatedPages.add([userMessage]);
      }

      emit(
        RagAgentStateUpdate(
          pagingState.copyWith(
            pages: updatedPages,
            isLoading: true,
            error: null,
          ),
        ),
      );

      try {
        final response = await repository.callRagAgent(
          payload: RAGAgentPayload(
            message: event.messageString,
            teacherId: 'my_test_corpus',
            role: 'user',
            file: event.file,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        if (response != null && response.statusCode == 200) {
          final RagAgentResponse agentMessage = RagAgentResponse.fromJson(
            response.data,
          );

          final List<List<RagAgentResponse>> replyPages = List.from(
            updatedPages,
          );
          if (replyPages.isNotEmpty) {
            replyPages[replyPages.length - 1] = [
              agentMessage,
              ...replyPages.last,
            ];
          } else {
            replyPages.add([agentMessage]);
          }

          emit(
            RagAgentStateUpdate(
              pagingState.copyWith(pages: replyPages, isLoading: false),
            ),
          );
        } else {
          emit(RagAgentFailure('Failed to get agent response'));
        }
      } catch (error) {
        emit(RagAgentFailure(error.toString()));
      }
    });

    on<FetchRagAgentChatHistory>((event, emit) async {
      PagingState<int, RagAgentResponse> pagingState;
      if (state is RagAgentStateUpdate) {
        pagingState = (state as RagAgentStateUpdate).state;
      } else {
        pagingState = PagingState<int, RagAgentResponse>();
      }

      if (pagingState.isLoading || !pagingState.hasNextPage) return;

      emit(RagAgentStateUpdate(pagingState.copyWith(isLoading: true, error: null)));

      try {
        final int nextOffset =
            (pagingState.keys?.last ?? 0) +
            (pagingState.pages?.lastOrNull?.length ?? 0);
        final response = await repository.fetchRagChatHistory(
          teacherId: event.teacherId,
          limit: event.pageSize,
          offset: nextOffset,
        );
        if (response != null && response.statusCode == 200) {
          final List data = response.data;
          final messages = data
              .map((e) => RagAgentResponse.fromJson(e))
              .toList()
              .cast<RagAgentResponse>();
          final isLastPage = messages.length < event.pageSize;

          final newPagingState = pagingState.copyWith(
            pages: [...?pagingState.pages, messages],
            keys: [...pagingState.keys ?? [], nextOffset],
            hasNextPage: !isLastPage,
            isLoading: false,
          );
          emit(RagAgentStateUpdate(newPagingState));
        } else {
          emit(RagAgentFailure('Failed to fetch chat history'));
        }
      } catch (error) {
        emit(RagAgentFailure(error.toString()));
      }
    });
  }
}
