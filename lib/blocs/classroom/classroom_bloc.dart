import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:lumen_slate/models/classroom_extended.dart';
import 'package:meta/meta.dart';
import '../../models/classroom.dart';
import '../../repositories/classroom_repository.dart';

part 'classroom_event.dart';
part 'classroom_state.dart';

class ClassroomBloc extends Bloc<ClassroomEvent, ClassroomState> {
  final ClassroomRepository classroomRepository;

  ClassroomBloc({required this.classroomRepository}) : super(ClassroomInitial()) {
    on<LoadClassrooms>(_onLoadClassrooms);
    on<RefreshClassrooms>(_onRefreshClassrooms);
  }

  Future<void> _onLoadClassrooms(
    LoadClassrooms event,
    Emitter<ClassroomState> emit,
  ) async {
    final currentState = state;
    List<Classroom> classrooms = [];
    List<ClassroomExtended> extendedClassrooms = [];
    if (currentState is ClassroomLoadSuccess && event.offset != 0) {
      classrooms = List.from(currentState.classrooms);
    } else {
      emit(ClassroomLoading());
    }
    try {
      final response = await classroomRepository.getClassrooms(
        teacherId: event.teacherId,
        limit: event.limit,
        offset: event.offset,
        extended: event.extended,
      );
      if (response.statusCode == 200 && response.data is List) {
        if (event.extended) {
          for (final item in response.data) {
            extendedClassrooms.add(ClassroomExtended.fromJson(item));
          }
          emit(ClassroomLoadExtendedSuccess(
            classrooms: extendedClassrooms,
          ));
        } else {
          for (final item in response.data) {
            classrooms.add(Classroom.fromJson(item));
          }
          emit(ClassroomLoadSuccess(
            classrooms: classrooms,
          ));
        }
      } else {
        emit(ClassroomLoadFailure('Failed to load classrooms'));
      }
    } catch (e) {
      emit(ClassroomLoadFailure(e.toString()));
    }
  }

  Future<void> _onRefreshClassrooms(
    RefreshClassrooms event,
    Emitter<ClassroomState> emit,
  ) async {
    emit(ClassroomLoading());
    add(LoadClassrooms(teacherId: event.teacherId));
  }
}
