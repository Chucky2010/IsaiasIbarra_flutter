import 'dart:async';

import 'package:mi_proyecto/data/task_repository.dart';
import 'package:mi_proyecto/domain/task.dart';
import 'package:mi_proyecto/data/assistant_repository.dart';



class TareasService {
  final TaskRepository _taskRepository = TaskRepository();
  final AssistantRepository _assistantRepository = AssistantRepository();

  List<Task> obtenerTareas() {
    try {
      return _taskRepository.getTasks();
    } catch (e) {
      throw Exception('Error al obtener tareas: $e');
    }
  }

  void agregarTarea(Task tarea) {
    try {
      _taskRepository.addTask(tarea);
    } catch (e) {
      throw Exception('Error al agregar tarea: $e');
    }
  }

  // Eliminar una tarea
  void eliminarTarea(int index) {
    try {
      _taskRepository.removeTask(index);
    } catch (e) {
      throw Exception('Error al eliminar tarea: $e');
    }
  }

  void modificarTarea(int index, Task tarea) {
    try {
      _taskRepository.updateTask(index, tarea);
    } catch (e) {
      throw Exception('Error al modificar tarea: $e');
    }
  }

     Task? getTaskById(int index) {
    try {
      return _taskRepository.getTaskById(index);
    } catch (e) {
      throw Exception('Error al obtener tarea por ID: $e');
    }
  }

    List<String> obtenerPasos(String titulo, DateTime fechaLimite) {
    try {
      return _assistantRepository.generarPasos(titulo, fechaLimite);
    } catch (e) {
      throw Exception('Error al obtener pasos: $e');
    }
  }
  
  List<Task> obtenerTareasConPasos() {
  final tareas = obtenerTareas();
  for (var tarea in tareas) {
    tarea.pasos = obtenerPasos(tarea.title, tarea.fechalimite);
  }
  return tareas;
}

  List<Task> obtenerMasTareas(int nextTaskId, int count) {
    try {
      return _taskRepository.loadMoreTasks(nextTaskId, count);
    } catch (e) {
      throw Exception('Error al obtener más tareas: $e');
    }
  }
}
