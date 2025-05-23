import 'dart:async';
import 'package:mi_proyecto/data/assistant_repository.dart';
import 'package:mi_proyecto/data/task_repository.dart';
import 'package:mi_proyecto/domain/task.dart';

class TareasService {
  final TaskRepository _taskRepository = TaskRepository();
  final AssistantRepository _assistantRepository = AssistantRepository(); // Instancia del nuevo repositorio

  // Método para obtener las tareas iniciales con pasos
  Future<List<Task>> getTasksWithSteps({int limite = 4}) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));

    // Obtiene las primeras tareas del repositorio
    final tareas = _taskRepository.getTasks().take(limite).toList();

    // Genera pasos para las tareas
    return _addStepsToTasks(tareas);
  }

  // Método para cargar más tareas con pasos (paginación)
  Future<List<Task>> getMoreTasksWithSteps({required int inicio, int limite = 4}) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));

    // Obtiene las tareas adicionales del repositorio
    final tareas = _taskRepository.getTasks().skip(inicio).take(limite).toList();

     // Itera sobre cada tarea y reemplaza la fecha límite
    final tareasConFechaActualizada = tareas.map((tarea) {
      return Task(
        titulo: tarea.titulo,
        tipo: tarea.tipo,
        descripcion: tarea.descripcion,
        fecha: tarea.fecha,
        fechaLimite: DateTime.now().add(const Duration(days: 1)), // Reemplaza la fecha límite con el día actual + 1
        pasos: tarea.pasos,
      );
    }).toList();

    // Genera pasos para las tareas
    return _addStepsToTasks(tareasConFechaActualizada);
  }

  // Método privado para agregar pasos a las tareas
  Future<List<Task>> _addStepsToTasks(List<Task> tareas) async {
    return await Future.wait(tareas.map((tarea) async {
      if (tarea.pasos == null || tarea.pasos!.isEmpty) {
        final pasos = await generarPasos(tarea.titulo, tarea.fechaLimite);
        return Task(
          titulo: tarea.titulo,
          tipo: tarea.tipo,
          descripcion: tarea.descripcion,
          fecha: tarea.fecha,
          fechaLimite: tarea.fechaLimite,
          pasos: pasos,
        );
      }
      return tarea;
    }));
  }

  Future<Task> agregarTarea(Task tarea) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));

    // Genera pasos para la tarea
    final pasos = await generarPasos(tarea.titulo, tarea.fechaLimite);

    // Crea una nueva tarea con los pasos generados
    final nuevaTarea = Task(
      titulo: tarea.titulo,
      tipo: tarea.tipo,
      descripcion: tarea.descripcion,
      fecha: tarea.fecha,
      fechaLimite: tarea.fechaLimite,
      pasos: pasos,
    );

    // Agrega la nueva tarea al repositorio
    _taskRepository.addTask(nuevaTarea);

    return nuevaTarea;
  }

  Future<void> eliminarTarea(int index) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));
    _taskRepository.removeTask(index);
  }

  Future<Task> actualizarTarea(int index, Task tareaActualizada) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));

    // Genera pasos actualizados para la tarea
    final pasos = await generarPasos(tareaActualizada.titulo, tareaActualizada.fechaLimite);

    // Crea una tarea actualizada con los pasos generados
    final tareaConPasos = Task(
      titulo: tareaActualizada.titulo,
      tipo: tareaActualizada.tipo,
      descripcion: tareaActualizada.descripcion,
      fecha: tareaActualizada.fecha,
      fechaLimite: tareaActualizada.fechaLimite,
      pasos: pasos,
    );

    // Actualiza la tarea en el repositorio
    _taskRepository.updateTask(index, tareaConPasos);

    return tareaConPasos;
  }

  Future<List<String>> generarPasos(String titulo, DateTime? fechaLimite) async {
    List<String> pasos = [];

    pasos = await _assistantRepository.generarPasos(titulo, fechaLimite);
    // Retorna solo los dos primeros pasos
    pasos = pasos.sublist(0, pasos.length > 2 ? 2 : pasos.length);
    return pasos;
  }
}