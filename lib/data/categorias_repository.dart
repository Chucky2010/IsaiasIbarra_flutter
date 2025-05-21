// services/categoria_service.dart
import 'package:mi_proyecto/api/service/categoria_service.dart'; // Importa tu repositorio
import 'package:mi_proyecto/data/base_repository.dart';
import 'package:mi_proyecto/domain/categoria.dart'; // Importa tu entidad Categoria
import 'package:flutter/foundation.dart'; // Para debugPrint

class CategoriaRepository extends BaseRepository {
  // Inyecta la dependencia del repositorio
  final CategoriaService _categoriaService = CategoriaService();

  // Constructor que recibe la instancia del repositorio
  CategoriaRepository();

  /// Obtiene la lista completa de categorías desde el repositorio.

  Future<List<Categoria>> obtenerCategorias_old() async {
    try {
      // Llama al método del repositorio para obtener los datos
      final categorias = await _categoriaService.getCategorias();
      return categorias;
    } catch (e) {
      // Puedes añadir lógica de logging o manejo de errores específico del servicio aquí
      debugPrint('Error en CategoriaService al obtener categorías: $e');
      rethrow;
    }
  }

  /// Obtiene todas las categorías
  Future<List<Categoria>> obtenerCategorias() async {
    try {
      logOperationStart('obtener', 'categorías');

      final categorias = await _categoriaService.getCategorias();

      logOperationSuccess('obtenidas', 'categorías');
      return categorias;
    } catch (e) {
      return handleError(e, 'al obtener', 'categorías');
    }
  }

  /* Future<void> crearCategoria_old(Map<String, dynamic> categoriaData) async {
    try {
      // Llama al método del repositorio para crear la categoría
      await _categoriaService.crearCategoria(categoriaData);
      debugPrint('Categoría creada exitosamente.');
    } catch (e) {
      debugPrint('Error en CategoriaService al crear categoría: $e');
      rethrow;
    }
  }*/

  Future<void> crearCategoria(Map<String, dynamic> categoriaData) async {
    try {
      logOperationStart('crear', 'categoría');

      await _categoriaService.crearCategoria(categoriaData);

      logOperationSuccess('creada', 'categoría');
    } catch (e) {
      handleError(e, 'al crear', 'categoría');
    }
  }

  Future<void> actualizarCategoria_old(
    String id,
    Map<String, dynamic> categoriaData,
  ) async {
    try {
      // Llama al método del repositorio para editar la categoría
      await _categoriaService.editarCategoria(id, categoriaData);
      debugPrint('Categoría con ID $id actualizada exitosamente.');
    } catch (e) {
      debugPrint('Error en CategoriaService al actualizar categoría $id: $e');
      rethrow;
    }
  }

  Future<void> actualizarCategoria(
    String id,
    Map<String, dynamic> categoriaData,
  ) async {
    try {
      // Llama al método del repositorio para editar la categoría
      await _categoriaService.editarCategoria(id, categoriaData);
      logOperationSuccess('editada', 'categoría', id);
    } catch (e) {
      handleError(e, 'al editar', 'categoría');
      rethrow;
    }
  }

  Future<void> eliminarCategoria(String id) async {
    try {
      // Llama al método del repositorio para eliminar la categoría
      checkIdNotEmpty(id, 'categoría');
      logOperationStart('eliminar', 'categoría', id);
      await _categoriaService.eliminarCategoria(id);
      debugPrint('Categoría con ID $id eliminada exitosamente.');
      logOperationSuccess('eliminada', 'categoría', id);
    } catch (e) {
      debugPrint('Error en CategoriaService al eliminar categoría $id: $e');
      handleError(e, 'al eliminar', 'categoría');
      rethrow;
    }
  }
}