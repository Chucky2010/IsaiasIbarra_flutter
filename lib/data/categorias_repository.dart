// services/categoria_service.dart
import 'package:mi_proyecto/api/service/categoria_service.dart'; // Importa tu repositorio
import 'package:mi_proyecto/data/base_repository.dart'; // Importa BaseRepository
import 'package:mi_proyecto/domain/categoria.dart'; // Importa tu entidad Categoria
import 'package:flutter/foundation.dart'; // Para debugPrint

class CategoriaRepository extends BaseRepository {
  // Inyecta la dependencia del repositorio
  final CategoriaService _categoriaService = CategoriaService();

  // Constructor que recibe la instancia del repositorio
  CategoriaRepository();
  /// Obtiene la lista completa de categorías desde el repositorio.
  Future<List<Categoria>> obtenerCategorias() async {
    return executeWithTryCatch(
      () async {
        final categorias = await _categoriaService.getCategorias();
        return validateListNotEmpty(
          categorias,
          'No se encontraron categorías disponibles',
        );
      },
      'obtener categorías',
    );
  }
  Future<void> crearCategoria(Map<String, dynamic> categoriaData) async {
    return executeWithTryCatch(
      () async {
        await _categoriaService.crearCategoria(categoriaData);
        debugPrint('Categoría creada exitosamente.');
      },
      'crear categoría',
    );
  }
  Future<void> actualizarCategoria(String id, Map<String, dynamic> categoriaData) async {
    return executeWithTryCatch(
      () async {
        await _categoriaService.editarCategoria(id, categoriaData);
        debugPrint('Categoría con ID $id actualizada exitosamente.');
      },
      'actualizar categoría',
    );
  }
  Future<void> eliminarCategoria(String id) async {
    return executeWithTryCatch(
      () async {
        await _categoriaService.eliminarCategoria(id);
        debugPrint('Categoría con ID $id eliminada exitosamente.');
      },
      'eliminar categoría',
    );
  }
}