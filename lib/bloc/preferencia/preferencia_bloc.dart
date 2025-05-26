import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/preferencia/preferencia_event.dart';
import 'package:mi_proyecto/bloc/preferencia/preferencia_state.dart';
import 'package:mi_proyecto/data/preferencia_repository.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class PreferenciaBloc extends Bloc<PreferenciaEvent, PreferenciaState> {
  final PreferenciaRepository _preferenciaRepository =
      di<PreferenciaRepository>();

  PreferenciaBloc() : super(PreferenciaInitial()) {
    on<LoadPreferences>(_onLoadPreferences);
    on<SavePreferences>(_onSavePreferences);
    on<ChangeCategory>(_onChangeCategory);
    on<ResetFilters>(_onResetFilters);
  }

  Future<void> _onLoadPreferences(
    LoadPreferences event,
    Emitter<PreferenciaState> emit,
  ) async {
    emit(PreferenciaLoading());

    try {
      // Obtener las categorías seleccionadas del repositorio
      final categoriasSeleccionadas =
          await _preferenciaRepository.obtenerCategoriasSeleccionadas();

      emit(
        PreferenciasLoaded(
          categoriasSeleccionadas: categoriasSeleccionadas,
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(PreferenciaError(e, TipoOperacionPreferencia.cargar));
      }
    }
  }

  Future<void> _onSavePreferences(
    SavePreferences event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      // Emitir un estado de carga para mostrar al usuario que está procesando
      emit(PreferenciaLoading());

      // Primero guardamos en la caché local (si es necesario)
      await _preferenciaRepository.guardarCategoriasSeleccionadas(
        event.selectedCategories,
      );

      // Luego sincronizamos con la API (esto es lo importante)
      await _preferenciaRepository.guardarCambiosEnAPI();

      // Emitir estado de éxito
      emit(
        PreferenciasSaved(
          categoriasSeleccionadas: event.selectedCategories,
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(PreferenciaError(e, TipoOperacionPreferencia.guardar));
      }
    }
  }

  Future<void> _onChangeCategory(
    ChangeCategory event,
    Emitter<PreferenciaState> emit,
  ) async {
    // Obtener el estado actual
    if (state is! PreferenciasLoaded) {
      return;
    }

    final currentState = state as PreferenciasLoaded;
    List<String> updatedCategories = List.from(
      currentState.categoriasSeleccionadas,
    );

    // Primero emitir el cambio local (inmediato)
    if (event.selected) {
      if (!updatedCategories.contains(event.category)) {
        updatedCategories.add(event.category);
      }
    } else {
      updatedCategories.remove(event.category);
    }

    // Emitir el nuevo estado inmediatamente
    emit(
      PreferenciasLoaded(
        categoriasSeleccionadas: updatedCategories,
        lastUpdated: DateTime.now(),
      ),
    );

    // Luego realizar la operación de persistencia en segundo plano
    try {
      if (event.selected) {
        await _preferenciaRepository.agregarCategoriaFiltro(event.category);
      } else {
        await _preferenciaRepository.eliminarCategoriaFiltro(event.category);
      }
    } catch (e) {
      // Solo emitir error si es realmente grave, para no interrumpir la experiencia
      if (e is ApiException && e.statusCode! >= 500) {
        emit(PreferenciaError(e, TipoOperacionPreferencia.cambiarCategoria));
      }
    }
  }

  Future<void> _onResetFilters(
    ResetFilters event,
    Emitter<PreferenciaState> emit,
  ) async {
    emit(PreferenciaLoading());

    try {
      // Limpiar todas las categorías seleccionadas (solo modifica la caché)
      await _preferenciaRepository.limpiarFiltrosCategorias();

      // Guardar los cambios en la API inmediatamente
      await _preferenciaRepository.guardarCambiosEnAPI();

      // Emitir estado de reseteo con lista vacía para asegurar una UI consistente
      emit(
        PreferenciasSaved(
          categoriasSeleccionadas: [],
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(PreferenciaError(e, TipoOperacionPreferencia.reiniciar));
      }
    }
  }
}
