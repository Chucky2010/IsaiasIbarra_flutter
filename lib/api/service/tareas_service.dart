import 'dart:async';

import 'package:mi_proyecto/data/task_repository.dart';
import 'package:mi_proyecto/domain/task.dart';

class TareasService {
  final TaskRepository _taskRepository = TaskRepository();

  static final TareasService _instance = TareasService._internal();
  factory TareasService() {
    return _instance;
  }
  TareasService._internal();

  Future<List<Task>> obtenerTareas() async {
    try {
      return _taskRepository.getTasks();
    } catch (e) {
      throw Exception('Error al obtener tareas: $e');
    }
  }

  Future<Task> agregarTarea(Task tarea) async {
    try {
      // Simula un retraso para imitar una llamada a una API
      _taskRepository.addTask(tarea);
      return tarea;
    } catch (e) {
     throw Exception('Error al agregar tarea: $e');
    }
  }

  Future<bool> eliminarTarea(int index) async {
   try {
      return _taskRepository.removeTask(index);
    } catch (e) {
      throw Exception('Error al eliminar tarea: $e');
    }
    
  }

  Future<bool> modificarTarea(int index, Task tarea) async {
    try {
      return _taskRepository.updateTask(index, tarea);
      
    } catch (e) {
      throw Exception('Error al modificar tarea: $e');
    }
  }

   Future<Task?> getTaskById(int index) async {
    try {
      return _taskRepository.getTaskById(index);
    } catch (e) {
      throw Exception('Error al obtener la tarea: $e');
    }
  }

  // Future<List<Map<String, dynamic>>> listarTareas() async
  // {
  //   // Simula un retraso para imitar una llamada a una API
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   return tareas;
  // }
}
