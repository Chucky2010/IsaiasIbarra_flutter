import 'dart:async';

import 'package:mi_proyecto/data/task_repository.dart';
import 'package:mi_proyecto/domain/task.dart';

class TareasService {
  final TaskRepository _taskRepository = TaskRepository();
  //final TaskRepository _taskRepository = TaskRepository();


  Future<List<Task>> obtenerTareas({int inicio = 0, int limite = 10}) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(seconds: 1));

    // Devuelve un subconjunto de tareas
    final tareas = _taskRepository.getTasks();
    return tareas.skip(inicio).take(limite).toList();
  }

  Future<void> agregarTarea(Task tarea) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));
    _taskRepository.addTask(tarea);
  }

  Future<void> eliminarTarea(int index) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));
    _taskRepository.removeTask(index);
  }

  Future<void> modificarTarea(int index, Task tareaModificada) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));
    final tareas = _taskRepository.getTasks();
    if (index >= 0 && index < tareas.length) {
      tareas[index] = tareaModificada;
    } else {
      throw Exception('Índice fuera de rango');
    }
  }

  // Future<List<Map<String, dynamic>>> listarTareas() async 
  // {
  //   // Simula un retraso para imitar una llamada a una API
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   return tareas;
  // }
}