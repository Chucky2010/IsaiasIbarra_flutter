import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/categoria/categoria_event.dart';
import 'package:mi_proyecto/bloc/categoria/categoria_state.dart';
import 'package:mi_proyecto/data/categoria_repository.dart';
import 'package:mi_proyecto/domain/categoria.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final CategoriaRepository categoriaRepository;

  CategoriaBloc({required this.categoriaRepository}) : super(CategoriaInitialState()) {
    on<LoadCategoriasEvent>(_onLoadCategorias);
    on<RefreshCategoriasEvent>(_onRefreshCategorias);
    on<AddCategoriaEvent>(_onAddCategoria);
    on<UpdateCategoriaEvent>(_onUpdateCategoria);
    on<DeleteCategoriaEvent>(_onDeleteCategoria);
  }

  Future<void> _onLoadCategorias(
    LoadCategoriasEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    emit(CategoriaLoadingState());
    try {
      final categorias = await categoriaRepository.getCategorias();
      emit(CategoriaLoadedState(categorias));
    } catch (e) {
      String errorMessage;
      if (e is ApiException) {
        errorMessage = 'Error ${e.statusCode}: ${e.message}';
      } else {
        errorMessage = 'Error al cargar categorías: $e';
      }
      emit(CategoriaErrorState(errorMessage));
    }
  }

  Future<void> _onRefreshCategorias(
    RefreshCategoriasEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    emit(CategoriaLoadingState());
    try {
      final categorias = await categoriaRepository.getCategorias();
      emit(CategoriaLoadedState(categorias, ultimaActualizacion: DateTime.now()));
      emit(CategoriaActionSuccess('Categorías actualizadas correctamente'));
    } catch (e) {
      String errorMessage;
      if (e is ApiException) {
        errorMessage = 'Error ${e.statusCode}: ${e.message}';
      } else {
        errorMessage = 'Error al actualizar categorías: $e';
      }
      emit(CategoriaErrorState(errorMessage));
    }
  }

  Future<void> _onAddCategoria(
    AddCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    try {
      await categoriaRepository.crearCategoria(event.categoria);
      // Emite un estado de éxito antes de recargar
      emit(CategoriaActionSuccess('Categoría agregada correctamente'));
      add(LoadCategoriasEvent());
    } catch (e) {
      String errorMessage;
      if (e is ApiException) {
        errorMessage = 'Error ${e.statusCode}: ${e.message}';
      } else {
        errorMessage = 'Error al agregar categoría: $e';
      }
      emit(CategoriaErrorState(errorMessage));
    }
  }

  Future<void> _onUpdateCategoria(
    UpdateCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    try {
      await categoriaRepository.actualizarCategoria(event.id, event.categoria);
      // Emite un estado de éxito antes de recargar
      emit(CategoriaActionSuccess('Categoría actualizada correctamente'));
      add(LoadCategoriasEvent());
    } catch (e) {
      String errorMessage;
      if (e is ApiException) {
        errorMessage = 'Error ${e.statusCode}: ${e.message}';
      } else {
        errorMessage = 'Error al editar categoría: $e';
      }
      emit(CategoriaErrorState(errorMessage));
    }
  }

  Future<void> _onDeleteCategoria(
    DeleteCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    try {
      await categoriaRepository.eliminarCategoria(event.categoriaId);
      // Emite un estado de éxito antes de recargar
      emit(CategoriaActionSuccess('Categoría eliminada correctamente'));
      add(LoadCategoriasEvent());
    } catch (e) {
      String errorMessage;
      if (e is ApiException) {
        errorMessage = 'Error ${e.statusCode}: ${e.message}';
      } else {
        errorMessage = 'Error al eliminar categoría: $e';
      }
      emit(CategoriaErrorState(errorMessage));
    }
  }
}