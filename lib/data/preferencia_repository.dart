import 'package:flutter/foundation.dart';
import 'package:mi_proyecto/api/service/preferencia_service.dart';
import 'package:mi_proyecto/data/base_repository.dart';
import 'package:mi_proyecto/domain/preferencia.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

class PreferenciaRepository extends BaseRepository {
  final PreferenciaService _preferenciaService = PreferenciaService();

  // Caché de preferencias para minimizar llamadas a la API
  Preferencia? _cachedPreferencias;

  /// Obtiene las categorías seleccionadas para filtrar las noticias
  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    try {
      logOperationStart('obtener', 'categorías seleccionadas');
      
      // Si no hay caché o es la primera vez, obtener de la API
      _cachedPreferencias ??= await _preferenciaService.getPreferencias();
      
      logOperationSuccess('obtenidas', 'categorías seleccionadas');
      return _cachedPreferencias!.categoriasSeleccionadas;
    } catch (e) {
      debugPrint('Error al obtener categorías seleccionadas: $e');
      // En caso de error desconocido, devolver lista vacía para no romper la UI
      return [];
    }
  }

  /// Guarda las categorías seleccionadas para filtrar las noticias
  Future<void> guardarCategoriasSeleccionadas(List<String> categoriaIds) async {
    try {
      logOperationStart('guardar', 'categorías seleccionadas');
      
      // Si no hay caché o es la primera vez, obtener de la API
      _cachedPreferencias ??= await _preferenciaService.getPreferencias();

      // Actualizar el objeto en caché
      _cachedPreferencias = Preferencia(categoriasSeleccionadas: categoriaIds);

      // Guardar en la API
      await _preferenciaService.guardarPreferencias(_cachedPreferencias!);
      
      logOperationSuccess('guardadas', 'categorías seleccionadas');
    } catch (e) {
      await handleError(e, 'al guardar', 'categorías seleccionadas');
    }
  }

  /// Añade una categoría a las categorías seleccionadas
  Future<void> agregarCategoriaFiltro(String categoriaId) async {
    try {
      logOperationStart('agregar', 'categoría al filtro', categoriaId);
      checkIdNotEmpty(categoriaId, 'categoría');
      
      final categorias = await obtenerCategoriasSeleccionadas();
      if (!categorias.contains(categoriaId)) {
        categorias.add(categoriaId);
        await guardarCategoriasSeleccionadas(categorias);
      }
      
      logOperationSuccess('agregada', 'categoría al filtro', categoriaId);
    } catch (e) {
      await handleError(e, 'al agregar', 'categoría al filtro');
    }
  }

  /// Elimina una categoría de las categorías seleccionadas
  Future<void> eliminarCategoriaFiltro(String categoriaId) async {
    try {
      logOperationStart('eliminar', 'categoría del filtro', categoriaId);
      checkIdNotEmpty(categoriaId, 'categoría');
      
      final categorias = await obtenerCategoriasSeleccionadas();
      categorias.remove(categoriaId);
      await guardarCategoriasSeleccionadas(categorias);
      
      logOperationSuccess('eliminada', 'categoría del filtro', categoriaId);
    } catch (e) {
      await handleError(e, 'al eliminar', 'categoría del filtro');
    }
  }

  /// Limpia todas las categorías seleccionadas
  Future<void> limpiarFiltrosCategorias() async {
    try {
      logOperationStart('limpiar', 'filtros de categorías');
      
      await guardarCategoriasSeleccionadas([]);

      // Limpiar también la caché
      if (_cachedPreferencias != null) {
        _cachedPreferencias = Preferencia.empty();
      }
      
      logOperationSuccess('limpiados', 'filtros de categorías');
    } catch (e) {
      await handleError(e, 'al limpiar', 'filtros de categorías');
    }
  }

  /// Limpia la caché para forzar una recarga desde la API
  void invalidarCache() {
    _cachedPreferencias = null;
    debugPrint('🔄 Caché de preferencias invalidada');
  }
}
