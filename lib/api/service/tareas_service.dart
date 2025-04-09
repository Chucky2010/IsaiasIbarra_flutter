import 'dart:async';

import 'package:mi_proyecto/data/task_repository.dart';
import 'package:mi_proyecto/domain/task.dart';



class TareasService {
  final TaskRepository _taskRepository = TaskRepository();

  // static final TareasService _instance = TareasService._internal();
  // factory TareasService() {
  //   return _instance;
  // }
  // TareasService._internal();

  List<Task> obtenerTareas() {
    try {
      return _taskRepository.getTasks();
    } catch (e) {
      throw Exception('Error al obtener tareas: $e');
    }
  }

  void agregarTarea(Task tarea) {
    //try {
      // Simula un retraso para imitar una llamada a una API
      _taskRepository.addTask(tarea);
    //   return tarea;
    // } catch (e) {
    //  throw Exception('Error al agregar tarea: $e');
    // }
  }

  void eliminarTarea(int index) {
   //try {
      return _taskRepository.removeTask(index);
    // } catch (e) {
    //   throw Exception('Error al eliminar tarea: $e');
    // }
    
  }

  void modificarTarea(int index, Task tarea) {
    //try {
       _taskRepository.updateTask(index, tarea);
      
    // } catch (e) {
    //   throw Exception('Error al modificar tarea: $e');
    // }
  }

   void getTaskById(int index) {
    //try {
      _taskRepository.getTaskById(index);
    // } catch (e) {
    //   throw Exception('Error al obtener la tarea: $e');
    // }
  }

  List<String> obtenerPasos(String titulo, DateTime fechaLimite)  {
    // Simula un retraso como si fuera una consulta a un servicio externo
    //await Future.delayed(const Duration(seconds: 1));

    // Formatea la fecha límite en un formato legible
     String fechaString = fechaLimite.toLocal().toString().split(' ')[0];

    // Genera pasos personalizados con la fecha límite
    return [
      'Paso 1: Planificar $titulo antes del $fechaString',
      'Paso 2: Ejecutar $titulo antes del $fechaString',
      'Paso 3: Revisar $titulo antes del $fechaString',
    ];
  }

  List<Task> obtenerMasTareas(int nextTaskId, int count) {
     return _taskRepository.loadMoreTasks(nextTaskId, count);
   }


  // Future<List<Map<String, dynamic>>> listarTareas() async
  // {
  //   // Simula un retraso para imitar una llamada a una API
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   return tareas;
  // }
}
