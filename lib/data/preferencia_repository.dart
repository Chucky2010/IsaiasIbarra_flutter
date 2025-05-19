import 'package:flutter/foundation.dart';
import 'package:mi_proyecto/api/service/preferencia_service.dart';
import 'package:mi_proyecto/data/base_repository.dart';
import 'package:mi_proyecto/domain/preferencia.dart';

class PreferenciaRepository extends BaseRepository {
  final PreferenciaService _preferenciaService = PreferenciaService(); // o new PreferenciaService()

  // Caché de preferencias para minimizar llamadas a la API
  Preferencia? _cachedPreferencias;
  /// Obtiene las categorías seleccionadas para filtrar las noticias
  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    try {
      // Utilizamos try-catch aquí en lugar de executeWithTryCatch porque necesitamos
      // devolver una lista vacía en caso de error para no romper la UI
      // Si no hay caché o es la primera vez, obtener de la API
      _cachedPreferencias ??= await executeWithTryCatch(
        () => _preferenciaService.getPreferencias(),
        'obtener preferencias',
      );

      return _cachedPreferencias!.categoriasSeleccionadas;
    } catch (e) {
      debugPrint('Error al obtener categorías seleccionadas: $e');
      // En caso de error, devolver lista vacía para no romper la UI
      return [];
    }
  }
  /// Guarda las categorías seleccionadas para filtrar las noticias
  Future<void> guardarCategoriasSeleccionadas(List<String> categoriaIds) async {
    return executeWithTryCatch(
      () async {
        // Si no hay caché o es la primera vez, obtener de la API
        _cachedPreferencias ??= await _preferenciaService.getPreferencias();

        // Actualizar el objeto en caché
        _cachedPreferencias = Preferencia(categoriasSeleccionadas: categoriaIds);

        // Guardar en la API
        await _preferenciaService.guardarPreferencias(_cachedPreferencias!);
      },
      'guardar categorías seleccionadas',
    );
  }
  /// Añade una categoría a las categorías seleccionadas
  Future<void> agregarCategoriaFiltro(String categoriaId) async {
    return executeWithTryCatch(
      () async {
        final categorias = await obtenerCategoriasSeleccionadas();
        if (!categorias.contains(categoriaId)) {
          categorias.add(categoriaId);
          await guardarCategoriasSeleccionadas(categorias);
        }
      },
      'agregar categoría al filtro',
    );
  }
  /// Elimina una categoría de las categorías seleccionadas
  Future<void> eliminarCategoriaFiltro(String categoriaId) async {
    return executeWithTryCatch(
      () async {
        final categorias = await obtenerCategoriasSeleccionadas();
        categorias.remove(categoriaId);
        await guardarCategoriasSeleccionadas(categorias);
      },
      'eliminar categoría del filtro',
    );
  }
  /// Limpia todas las categorías seleccionadas
  Future<void> limpiarFiltrosCategorias() async {
    return executeWithTryCatch(
      () async {
        await guardarCategoriasSeleccionadas([]);

        // Limpiar también la caché
        if (_cachedPreferencias != null) {
          _cachedPreferencias = Preferencia.empty();
        }
      },
      'limpiar filtros de categorías',
    );
  }

  /// Limpia la caché para forzar una recarga desde la API
  void invalidarCache() {
    _cachedPreferencias = null;
  }
}
