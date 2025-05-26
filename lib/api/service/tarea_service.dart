import 'package:mi_proyecto/api/service/base_service.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/domain/tarea.dart';


class TareaService extends BaseService {
  final String _endpoint = ApiConstantes.tareasEndpoint;

  /// Obtiene la lista de tareas de un usuario
  Future<List<Tarea>> obtenerTareasUsuario(usuario) async {
    final List<dynamic> tareasJson = await get<List<dynamic>>(
      '$_endpoint?usuario=$usuario',
      errorMessage: 'Error al obtener las tareas',
    );

    return tareasJson
        .map<Tarea>((json) => TareaMapper.fromMap(json as Map<String, dynamic>))
        .toList();
  }

  /// Crea una nueva tarea
  /// crea la tarea nueva
  Future<Tarea> crearTarea(Tarea tarea) async {
    final json = await post(
      _endpoint,
      data: tarea.toMap(),
      errorMessage: 'Error al crear la tarea',
    );

    return TareaMapper.fromMap(json);
  }

  /// Elimina una tarea existente
  Future<void> eliminarTarea(String tareaId) async {
    final url = '$_endpoint/$tareaId';
    await delete(url, errorMessage: 'Error al eliminar la tarea');
  }

  /// Actualiza una tarea existente
  Future<Tarea> actualizarTarea(Tarea tarea) async {
    final taskId = tarea.id;
    final url = '$_endpoint/$taskId';
    final json = await put(
      url,
      data: tarea.toMap(),
      errorMessage: 'Error al actualizar la tarea',
    );

    return TareaMapper.fromMap(json);
  }
}
