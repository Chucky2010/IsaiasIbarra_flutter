import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

/// La clase BaseRepository sirve como base para todos los repositorios de la aplicación.
/// Proporciona funcionalidad común y manejo de errores estandarizado.
abstract class BaseRepository<T> {
  /// Un método para validar entidades genéricas.
  /// Cada repositorio concreto debe implementar su propia lógica de validación.
  void validarEntidad(T entidad);

  /// Método utilitario para manejar excepciones de manera consistente.
  /// Diferencia entre ApiException y otras excepciones, permitiendo un manejo adecuado.
  Future<R> manejarExcepcion<R>(
    Future<R> Function() accion, {
    String mensajeError = 'Error desconocido',
  }) async {
    try {
      return await accion();
    } catch (e) {
      if (e is ApiException) {
        // Propagar ApiException directamente
        rethrow;
      } else {
        // Envolver otras excepciones en ApiException con mensaje contextual
        throw ApiException('$mensajeError: $e');
      }
    }
  }

  /// Valida que un valor no esté vacío y lanza una excepción si lo está.
  void validarNoVacio(String? valor, String nombreCampo) {
    if (valor == null || valor.isEmpty) {
      throw ApiException(
        '$nombreCampo${ValidacionConstantes.campoVacio}',
        statusCode: 400,
      );
    }
  }

  /// Valida que un ID no esté vacío.
  void validarId(String? id) {
    validarNoVacio(id, 'ID');
  }

  /// Valida que una fecha no esté en el futuro
  /// @param fecha La fecha a validar
  /// @param nombreCampo Nombre del campo para el mensaje de error
  /// @param mensajeError Mensaje de error personalizado (opcional)
  void validarFechaNoFutura(DateTime fecha, String nombreCampo) {
    if (fecha.isAfter(DateTime.now())) {
      throw ApiException(
        '$nombreCampo${ValidacionConstantes.noFuturo}',
        statusCode: 400,
      );
    }
  }
}

/// Extensión del BaseRepository que incluye capacidades de caché.
abstract class CacheableRepository<T> extends BaseRepository<T> {
  /// Almacenamiento en caché de datos
  List<T>? _cache;

  /// Flag para indicar si hay cambios pendientes
  bool _cambiosPendientes = false;

  /// Obtiene datos, preferentemente desde la caché
  Future<List<T>> obtenerDatos({bool forzarRecarga = false}) async {
    // Si forzarRecarga es true o no hay caché, cargar desde la fuente de datos
    if (forzarRecarga || _cache == null) {
      _cache = await cargarDatos();
    }

    return _cache ?? [];
  }

  /// Carga datos desde la fuente de datos
  Future<List<T>> cargarDatos();

  /// Marca que hay cambios pendientes
  void marcarCambiosPendientes() {
    _cambiosPendientes = true;
  }

  /// Verifica si hay cambios pendientes
  bool hayCambiosPendientes() {
    return _cambiosPendientes;
  }

  /// Limpia la caché para forzar una recarga
  void invalidarCache() {
    _cache = null;
    _cambiosPendientes = false;
  }
}
