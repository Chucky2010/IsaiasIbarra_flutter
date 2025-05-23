import 'package:mi_proyecto/api/service/preferencia_service.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/data/base_repository.dart';
import 'package:mi_proyecto/domain/preferencia.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';
import 'package:mi_proyecto/helpers/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart';

/// Repositorio para gestionar las preferencias del usuario.
/// Utiliza caché para minimizar las llamadas a la API.
class PreferenciaRepository extends CacheableRepository<Preferencia> {
  final PreferenciaService _preferenciaService = PreferenciaService();
  final SecureStorageService _secureStorage = di<SecureStorageService>();

  // Caché de preferencias del usuario actual
  Preferencia? _cachedPreferencias;

  @override
  void validarEntidad(Preferencia preferencia) {
    validarNoVacio(preferencia.email, ValidacionConstantes.email);
  }

  @override
  Future<List<Preferencia>> cargarDatos() async {
    // Inicializar preferencias del usuario si es necesario
    if (_cachedPreferencias == null) {
      await inicializarPreferenciasUsuario();
    }
    // Devolver lista con un solo elemento (preferencias del usuario actual)
    return _cachedPreferencias != null ? [_cachedPreferencias!] : [];
  }

  /// Inicializa las preferencias del usuario autenticado actual.
  /// Busca directamente por email las preferencias del usuario.
  /// Si no existen, crea unas preferencias vacías para ese email.
  Future<void> inicializarPreferenciasUsuario() async {
    return manejarExcepcion(() async {
      // Obtener el email del usuario autenticado
      final email = await _secureStorage.getUserEmail();
      if (email == null || email.isEmpty) {
        throw ApiException(AppConstantes.notUser, statusCode: 401);
      }
        try {
        // Buscar directamente por email (más eficiente)
        final preferencia = await _preferenciaService.obtenerPreferenciaPorEmail(email);
        // Guardar en caché
        _cachedPreferencias = preferencia;
      } catch (e) {
        // Si no encuentra la preferencia (error 404), crear una nueva
        if (e is ApiException && e.statusCode == 404) {
          _cachedPreferencias = await _preferenciaService.crearPreferencia(email);
        } else {
          // Si es otro tipo de error, propagarlo
          rethrow;
        }
      }
    }, mensajeError: PreferenciaConstantes.errorInit);
  }
  
  /// Obtiene las categorías seleccionadas para filtrar las noticias
  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    return manejarExcepcion(() async {
      // Si no hay caché o es la primera vez, inicializar preferencias
      if (_cachedPreferencias == null) {
        await inicializarPreferenciasUsuario();
      }

      return _cachedPreferencias?.categoriasSeleccionadas ?? [];
    }, mensajeError: CategoriaConstantes.mensajeError);
  }

  /// Actualiza la caché local con las nuevas categorías (sin hacer PUT a la API)
  Future<void> _actualizarCacheLocal(List<String> categoriaIds) async {
    return manejarExcepcion(() async {
      // Si no hay caché, inicializar preferencias
      if (_cachedPreferencias == null) {
        await inicializarPreferenciasUsuario();
      }
      
      // Obtener el email actual desde la caché o buscar uno nuevo
      final email = _cachedPreferencias?.email ?? 
                   (await _secureStorage.getUserEmail() ?? AppConstantes.usuarioDefault);
      
      // Actualizar el objeto en caché
      _cachedPreferencias = Preferencia(
        email: email,
        categoriasSeleccionadas: categoriaIds
      );
      
      // Marcar que hay cambios pendientes
      marcarCambiosPendientes();
    }, mensajeError: AppConstantes.errorCache);
  }

  /// Guarda las categorías seleccionadas en la API (solo cuando se presiona Aplicar Filtros)
  Future<void> guardarCambiosEnAPI() async {
    return manejarExcepcion(() async {
      // Verificar si hay cambios pendientes
      if (!hayCambiosPendientes()) {
        return;
      }
      
      // Verificar que la caché esté inicializada
      if (_cachedPreferencias == null) {
        await inicializarPreferenciasUsuario();
        // Si no hay cambios después de inicializar, no hay nada que guardar
        if (!hayCambiosPendientes()) {
          return;
        }
      }
      
      // Guardar en la API
      await _preferenciaService.guardarPreferencias(_cachedPreferencias!);
      
      // Una vez guardado, ya no hay cambios pendientes
      super.invalidarCache(); // Esto también establece _cambiosPendientes = false
    }, mensajeError: PreferenciaConstantes.errorUpdated);
  }

  /// Este método se mantiene para compatibilidad, pero ahora solo actualiza cache
  /// y no hace llamadas a la API
  Future<void> guardarCategoriasSeleccionadas(List<String> categoriaIds) async {
    return _actualizarCacheLocal(categoriaIds);
  }

  /// Añade una categoría a las categorías seleccionadas (solo en caché)
  Future<void> agregarCategoriaFiltro(String categoriaId) async {
    return manejarExcepcion(() async {
      final categorias = await obtenerCategoriasSeleccionadas();
      if (!categorias.contains(categoriaId)) {
        categorias.add(categoriaId);
        await _actualizarCacheLocal(categorias);
      }
    }, mensajeError: CategoriaConstantes.errorAdd);
  }

  /// Elimina una categoría de las categorías seleccionadas (solo en caché)
  Future<void> eliminarCategoriaFiltro(String categoriaId) async {
    return manejarExcepcion(() async {
      final categorias = await obtenerCategoriasSeleccionadas();
      categorias.remove(categoriaId);
      await _actualizarCacheLocal(categorias);
    }, mensajeError: CategoriaConstantes.errorDelete);
  }

  /// Limpia todas las categorías seleccionadas (solo en caché)
  Future<void> limpiarFiltrosCategorias() async {
    return _actualizarCacheLocal([]);
  }
  /// Sobreescribe el método de la clase base para también limpiar la preferencia cacheada
  @override
  void invalidarCache() {
    super.invalidarCache();
    _cachedPreferencias = null;
  }
}
