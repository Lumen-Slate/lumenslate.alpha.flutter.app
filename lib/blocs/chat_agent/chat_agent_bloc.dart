import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lumen_slate/common/components/base_message/message_barrel.dart';
import 'package:lumen_slate/serializers/agent_serializers/agent_response.dart';
import '../../repositories/ai/agent_repository.dart';
import '../../serializers/agent_serializers/agent_payload.dart';
import '../../serializers/agent_serializers/assessor_agent_serializer.dart';
import '../../serializers/agent_serializers/assignment_generator_general_serializer.dart';
import '../../serializers/agent_serializers/report_card_agent.dart';

part 'chat_agent_event.dart';
part 'chat_agent_state.dart';

class ChatAgentBloc extends Bloc<ChatAgentEvent, ChatAgentState> {
  final AgentRepository repository;

  (TextResponseMessage, AgentResponseMessage?) extractResponseMessage(AIRawResponse response) {
    final textMessage = TextResponseMessage(response: response);

    AgentResponseMessage? specializedMessage;

    if (response.agentName == 'assignment_generator_general'
    // || response.agentName == 'assignment_generator_tailored'
    ) {
      specializedMessage = AssignmentGeneratorGeneralResponseMessage(
        response: AssignmentGeneratorSerializer.fromJson(response.data.toJson()),
      );
    } else if (response.agentName == 'assessor_agent') {
      specializedMessage = AssessmentGeneratorResponseMessage(
        serializer: AssessorAgentSerializer.fromJson(response.data.toJson()),
      );
    } else if (response.agentName == 'report_card_generator') {
      specializedMessage = ReportCardGeneratorResponseMessage(
        serializer: ReportCardAgentSerializer.fromJson(response.data.toJson()),
      );
    }

    return (textMessage, specializedMessage);
  }

  ChatAgentBloc({required this.repository}) : super(ChatAgentInitial()) {
    on<CallAgent>((event, emit) async {
      PagingState<int, BaseMessage> pagingState;
      if (state is ChatAgentStateUpdated) {
        pagingState = (state as ChatAgentStateUpdated).state;
      } else {
        pagingState = PagingState<int, BaseMessage>();
      }

      // Create user message
      final userMessage = TextRequestMessage(
        content: event.messageString,
        senderName: 'User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        teacherId: event.teacherId,
        sessionId: '',
      );

      final List<List<BaseMessage>> updatedPages = List.from(pagingState.pages ?? []);
      if (updatedPages.isNotEmpty) {
        updatedPages[updatedPages.length - 1] = [userMessage, ...updatedPages.last];
      } else {
        updatedPages.add([userMessage]);
      }

      emit(ChatAgentStateUpdated(pagingState.copyWith(pages: updatedPages, isLoading: true, error: null)));

      try {
        final response = await repository.callAgent(
          payload: AgentPayload(
            teacherId: event.teacherId,
            message: event.messageString + (event.attachments ?? ''),
            file: event.file,
            role: 'user',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        if (response != null && response.statusCode == 200) {
          // call extractResponseMessage
          final (TextResponseMessage, AgentResponseMessage?) messages = extractResponseMessage(AIRawResponse.fromJson(response.data));

          // Append the agent reply to the last page
          final List<List<BaseMessage>> replyPages = List.from(updatedPages);
          if (replyPages.isNotEmpty) {
            // replyPages[replyPages.length - 1] = [agentMessage, ...replyPages.last];
            replyPages[replyPages.length - 1] = [messages.$1, if (messages.$2 != null) messages.$2!, ...replyPages.last];
          } else {
            // replyPages.add([agentMessage]);
            replyPages.add([messages.$1, if (messages.$2 != null) messages.$2!]);
          }

          emit(ChatAgentStateUpdated(pagingState.copyWith(pages: replyPages, isLoading: false)));
        } else {
          emit(ChatAgentFailure('Failed to get agent response'));
        }
      } catch (error) {
        emit(ChatAgentFailure(error.toString()));
      }
    });

    on<FetchAgentChatHistory>((event, emit) async {
      PagingState<int, BaseMessage> pagingState;
      if (state is ChatAgentStateUpdated) {
        pagingState = (state as ChatAgentStateUpdated).state;
      } else {
        pagingState = PagingState<int, BaseMessage>();
      }

      if (pagingState.isLoading || !pagingState.hasNextPage) return;

      emit(ChatAgentStateUpdated(pagingState.copyWith(isLoading: true, error: null)));

      try {
        final int nextOffset = (pagingState.keys?.last ?? 0) + (pagingState.pages?.lastOrNull?.length ?? 0);
        final response = await repository.fetchChatHistory(
          teacherId: event.teacherId,
          limit: event.pageSize,
          offset: nextOffset,
        );
        if (response != null && response.statusCode == 200) {
          final List data = response.data;
          final messages = data.map((e) {
            final rawResponse = AIRawResponse.fromJson(e);
            final (textMessage, specializedMessage) = extractResponseMessage(rawResponse);
            return [textMessage, if (specializedMessage != null) specializedMessage];
          }).expand((pair) => pair).toList();
          final isLastPage = messages.length < event.pageSize;

          final newPagingState = pagingState.copyWith(
            pages: [...?pagingState.pages, messages],
            keys: [...pagingState.keys ?? [], nextOffset],
            hasNextPage: !isLastPage,
            isLoading: false,
          );
          emit(ChatAgentStateUpdated(newPagingState));
        } else {
          emit(ChatAgentFailure('Failed to fetch chat history'));
        }
      } catch (error) {
        emit(ChatAgentFailure(error.toString()));
      }
    });
  }
}
