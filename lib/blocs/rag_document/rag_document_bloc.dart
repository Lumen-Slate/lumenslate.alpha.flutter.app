import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../repositories/ai/rag_agent_repository.dart';

part 'rag_document_event.dart';
part 'rag_document_state.dart';

class RagDocumentBloc extends Bloc<RagDocumentEvent, RagDocumentState> {
  final RagAgentRepository ragAgentRepository;

  RagDocumentBloc({required this.ragAgentRepository}) : super(RagDocumentInitial()) {
    on<FetchRagDocuments>((event, emit) async {
      emit(RagDocumentLoading());
      try {
        final response = await ragAgentRepository.fetchFilesForTeacher(teacherId: event.teacherId);
        if (response != null && response.statusCode == 200) {
          final docs = (response.data as List)
              .map((e) => RagDocument.fromJson(e as Map<String, dynamic>))
              .toList();
          emit(RagDocumentSuccess(docs));
        } else {
          emit(RagDocumentFailure('Failed to fetch documents'));
        }
      } catch (e) {
        emit(RagDocumentFailure('Error: $e'));
      }
    });
  }
}
