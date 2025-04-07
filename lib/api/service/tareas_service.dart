import 'dart:async';

import 'package:mi_proyecto/data/task_repository.dart';

class TareasService {
  final List<Map<String, dynamic>> _tareas = [];
  //final TaskRepository _taskRepository = TaskRepository();


  Future<List<Map<String, dynamic>>> obtenerTareas({int inicio = 0, int limite = 10}) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(seconds: 1));

    // Devuelve un subconjunto de tareas
    return _tareas.skip(inicio).take(limite).toList();
  }

  Future<void> agregarTarea(Map<String, dynamic> tarea) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));
    _tareas.add(tarea);
  }

  Future<void> eliminarTarea(int index) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));
    _tareas.removeAt(index);
  }

  Future<void> modificarTarea(int index, Map<String, dynamic> nuevaTarea) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));
    if (index >= 0 && index < _tareas.length) {
      _tareas[index] = nuevaTarea;
    } else {
      throw Exception('Índice fuera de rango');
    }
  }

  Future<List<Map<String, dynamic>>> listarTareas() async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));
    return _tareas;
  }
}