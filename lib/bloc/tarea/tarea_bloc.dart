import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/tarea/tarea_event.dart';
import 'package:mi_proyecto/bloc/tarea/tarea_state.dart';
import 'package:mi_proyecto/data/tarea_repository.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class TareaBloc extends Bloc<TareaEvent, TareaState> {
  final TareasRepository _tareaRepository = di<TareasRepository>();
  static const int _limitePorPagina = 5;

  TareaBloc() : super(TareaInitial()) {

    on<LoadTareasEvent>(_onLoadTareas);
    on<LoadMoreTareasEvent>(_onLoadMoreTareas);
    on<CreateTareaEvent>(_onCreateTarea);
    on<UpdateTareaEvent>(_onUpdateTarea);
    on<DeleteTareaEvent>(_onDeleteTarea);
  }

  Future<void> _onLoadTareas(
    LoadTareasEvent event,
    Emitter<TareaState> emit,
  ) async {
    emit(TareaLoading());
    try {
      final tareas = await _tareaRepository.obtenerTareas(
        forzarRecarga: event.forzarRecarga,
      );
      emit(
        TareaLoaded(
          tareas: tareas,
          lastUpdated: DateTime.now(),
          hayMasTareas: tareas.length >= _limitePorPagina,
          paginaActual: 0,
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(TareaError(e));
      }
    }
  }

  Future<void> _onLoadMoreTareas(
    LoadMoreTareasEvent event,
    Emitter<TareaState> emit,
  ) async {
    if (state is TareaLoaded) {
      final currentState = state as TareaLoaded;
      try {
        final nuevasTareas = await _tareaRepository.obtenerTareas(
          forzarRecarga: true,
        );

        emit(
          TareaLoaded(
            tareas: [...currentState.tareas, ...nuevasTareas],
            lastUpdated: DateTime.now(),
            hayMasTareas: nuevasTareas.length >= event.limite,
            paginaActual: event.pagina,
          ),
        );
      } catch (e) {
        if (e is ApiException) {
          emit(TareaError(e));
        }
      }
    }
  }

  Future<void> _onCreateTarea(
    CreateTareaEvent event,
    Emitter<TareaState> emit,
  ) async {
    try {
      final nuevaTarea = await _tareaRepository.agregarTarea(event.tarea);
      if (state is TareaLoaded) {
        final currentState = state as TareaLoaded;
        final tareas = [nuevaTarea, ...currentState.tareas];

        emit(
          TareaCreated(
            tareas,
            TipoOperacionTarea.crear,
            'Tarea creada exitosamente',
          ),
        );
        emit(
          TareaLoaded(
            tareas: tareas,
            lastUpdated: DateTime.now(),
            hayMasTareas: currentState.hayMasTareas,
            paginaActual: currentState.paginaActual,
          ),
        );
      }
    } catch (e) {
      if (e is ApiException) {
        emit(TareaError(e));
      }
    }
  }

  Future<void> _onUpdateTarea(
    UpdateTareaEvent event,
    Emitter<TareaState> emit,
  ) async {
    try {
      final tareaActualizada = await _tareaRepository.actualizarTarea(
        event.tarea,
      );
      if (state is TareaLoaded) {
        final currentState = state as TareaLoaded;
        final tareas =
            currentState.tareas.map((tarea) {
              return tarea.id == event.tarea.id ? tareaActualizada : tarea;
            }).toList();

        emit(
          TareaUpdated(
            tareas,
            TipoOperacionTarea.editar,
            'Tarea actualizada exitosamente',
          ),
        );
        emit(
          TareaLoaded(
            tareas: tareas,
            lastUpdated: DateTime.now(),
            hayMasTareas: currentState.hayMasTareas,
            paginaActual: currentState.paginaActual,
          ),
        );
      }
    } catch (e) {
      if (e is ApiException) {
        emit(TareaError(e));
      }
    }
  }

  Future<void> _onDeleteTarea(
    DeleteTareaEvent event,
    Emitter<TareaState> emit,
  ) async {
    try {
      await _tareaRepository.eliminarTarea(event.id);
      if (state is TareaLoaded) {
        final currentState = state as TareaLoaded;
        final tareas =
            currentState.tareas.where((t) => t.id != event.id).toList();

        emit(
          TareaDeleted(
            tareas,
            TipoOperacionTarea.eliminar,
            'Tarea eliminada exitosamente',
          ),
        );
        emit(
          TareaLoaded(
            tareas: tareas,
            lastUpdated: DateTime.now(),
            hayMasTareas: currentState.hayMasTareas,
            paginaActual: currentState.paginaActual,
          ),
        );
      }
    } catch (e) {
      if (e is ApiException) {
        emit(TareaError(e));
      }
    }
  }
}
