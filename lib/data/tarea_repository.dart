import 'package:mi_proyecto/api/service/tarea_service.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/data/base_repository.dart';
import 'package:mi_proyecto/domain/tarea.dart';
import 'package:mi_proyecto/domain/tarea_cache_prefs.dart';
import 'package:mi_proyecto/helpers/secure_storage_service.dart';
import 'package:mi_proyecto/helpers/shared_preferences_service.dart';
import 'package:watch_it/watch_it.dart';

class TareasRepository extends BaseRepository<Tarea> {
  final  _tareaService = di<TareaService>();
  final  _secureStorage = di<SecureStorageService>();
  final _sharedPreferences = di<SharedPreferencesService>();
  // Definimos una clave constante para almacenar/recuperar las tareas en caché
  static const String _tareasCacheKey = 'tareas_cache_prefs';
  String? usuarioAutenticado;

  // Funciones auxiliares para mapear objetos
  TareaCachePrefs _fromJson(Map<String, dynamic> json) =>
      TareaCachePrefsMapper.fromMap(json);
  Map<String, dynamic> _toJson(TareaCachePrefs cache) => cache.toMap();

  TareasRepository();

  //Trae el usuario autenticado desde el secure storage
  Future<String> _obtenerUsuarioAutenticado() async {
    usuarioAutenticado ??= await _secureStorage.getUserEmail();
    return usuarioAutenticado!;
  }

  /// Valida los campos de la entidad Tarea
  @override
  void validarEntidad(Tarea tarea) {
    validarNoVacio(tarea.titulo, ValidacionConstantes.tituloTarea);
    //agregar validaciones que correspondan
  }

  /// Obtiene el contenido de la caché actual
  Future<TareaCachePrefs?> _obtenerCache({
    TareaCachePrefs? defaultValue,
  }) async {
    return _sharedPreferences.getObject<TareaCachePrefs>(
      key: _tareasCacheKey,
      fromJson: _fromJson,
      defaultValue: defaultValue,
    );
  }

  /// Guarda una lista de tareas en la caché
  Future<bool> _guardarEnCache(List<Tarea> tareas) async {
    final usuario= await _obtenerUsuarioAutenticado();
    return _sharedPreferences.saveObject<TareaCachePrefs>(
      key: _tareasCacheKey,
      value: TareaCachePrefs(usuario: usuario, misTareas: tareas),
      toJson: _toJson,
    );
  }

  /// Actualiza la caché usando una función de transformación
  ///
  /// [updateFn]: Función que recibe la caché actual y retorna una nueva versión
  /// La caché siempre debe existir cuando se llama a este método, ya que se inicializa en obtenerTareas
  Future<bool> _actualizarCache(
    TareaCachePrefs Function(TareaCachePrefs cache) updateFn,
  ) async {
    return _sharedPreferences.updateObject<TareaCachePrefs>(
      key: _tareasCacheKey,
      updateFn:
          (current) => updateFn(current!), // Asumimos que current nunca es nulo
      fromJson: _fromJson,
      toJson: _toJson,
    );
  }

  /// Obtiene todas las tareas del usuario desde la API
  Future<List<Tarea>> obtenerTareasUsuario(String usuario) async {
    List<Tarea> tareasUsuario = await manejarExcepcion(
      () => _tareaService.obtenerTareasUsuario(usuario),
      mensajeError: TareasConstantes.mensajeError,
    );
    return tareasUsuario;
  }

  /// Obtiene todas las tareas con estrategia cache-first
  Future<List<Tarea>> obtenerTareas({bool forzarRecarga = false}) async {
    return manejarExcepcion(() async {
      List<Tarea> tareas = [];
      final usuario= await _obtenerUsuarioAutenticado();

      // Obtenemos el objeto desde SharedPreferences con un valor por defecto
      TareaCachePrefs? tareasCache = await _obtenerCache(
        defaultValue: TareaCachePrefs(
          usuario: usuario,
          misTareas: tareas,
        ),
      );

      // Si no coincide el usuario actual con el de la caché, invalidamos la caché
      if (usuario != tareasCache?.usuario) {
        await _sharedPreferences.remove(_tareasCacheKey);
        tareasCache = null;
      }

      // Si se fuerza la recarga, ignoramos la caché
      // Si no esta forzada la recarga y tenemos datos en caché, los usamos
      if (forzarRecarga != true && tareasCache != null && tareasCache.misTareas.isNotEmpty) {
        tareas = tareasCache.misTareas;
      } else {
        // Si no hay caché, cargamos desde la API
        tareas = await obtenerTareasUsuario(usuario);
        await _guardarEnCache(tareas);
      }
      return tareas;
    }, mensajeError: TareasConstantes.mensajeError);
  }

  /// Agrega una nueva tarea y actualiza la caché
  Future<Tarea> agregarTarea(Tarea tarea) async {
    return manejarExcepcion(() async {
      validarEntidad(tarea);
      final usuario= await _obtenerUsuarioAutenticado();

      // Verificamos si ya tiene email, de lo contrario lo obtenemos
      final tareaConEmail =
          (tarea.usuario.isEmpty)
              ? tarea.copyWith(usuario: usuario)
              : tarea;

      // Enviamos la tarea a la API
      final nuevaTarea = await _tareaService.crearTarea(
        tareaConEmail,
      ); // Actualizamos la caché usando el método auxiliar
      await _actualizarCache(
        (cache) => cache.copyWith(misTareas: [...cache.misTareas, nuevaTarea]),
      );
      return nuevaTarea;
    }, mensajeError: TareasConstantes.errorCrear);
  }

  /// Elimina una tarea y actualiza la caché
  Future<void> eliminarTarea(String tareaId) async {
    return manejarExcepcion(() async {
      validarId(tareaId);
      await _tareaService.eliminarTarea(
        tareaId,
      ); // Actualizamos la caché en un solo paso usando el método auxiliar
      await _actualizarCache((cache) {
        // Filtramos la tarea eliminada
        final tareasFiltradas =
            cache.misTareas.where((t) => t.id != tareaId).toList();

        // Creamos una nueva instancia con la lista filtrada
        return cache.copyWith(misTareas: tareasFiltradas);
      });
    }, mensajeError: TareasConstantes.errorEliminar);
  }

  /// Actualiza una tarea existente y la caché
  Future<Tarea> actualizarTarea(Tarea tarea) async {
    return manejarExcepcion(() async {
      validarId(tarea.id);
      validarEntidad(tarea);

      // Enviamos la tarea a la API
      final tareaActualizada = await _tareaService.actualizarTarea(
        tarea,
      ); // Actualizamos la caché en un solo paso usando el método auxiliar
      await _actualizarCache((cache) {
        // Creamos una nueva lista reemplazando la tarea actualizada
        final nuevasTareas =
            cache.misTareas.map((t) {
              return t.id == tarea.id ? tareaActualizada : t;
            }).toList();

        // Creamos una nueva instancia con la lista actualizada
        return cache.copyWith(misTareas: nuevasTareas);
      });
      return tareaActualizada;
    }, mensajeError: TareasConstantes.errorActualizar);
  }

  /// Limpia la caché del repositorio
  Future<void> limpiarCache() async {
    usuarioAutenticado = null;
  }
}
