import 'package:mi_proyecto/api/service/tareas_service.dart';

import '../domain/task.dart';

class TaskRepository {
  static final List<Task> inicial = [
    Task(
      title: 'Tarea 1',
      type: 'urgente',
      descripcion: 'Descripción de la tarea 1',
      fecha: DateTime(2024, 4, 7),
      fechalimite: DateTime.now().add(const Duration(days: 4)),
    ),
    Task(
      title: 'Tarea 2',
      type: 'normal',
      descripcion: 'Descripción de la tarea 2',
      fecha: DateTime(2024, 4, 8),
      fechalimite: DateTime.now().add(const Duration(days: 4)),
    ),
    Task(
      title: 'Tarea 3',
      type: 'urgente',
      descripcion: 'Descripción de la tarea 3',
      fecha: DateTime(2024, 4, 9),
      fechalimite: DateTime.now().add(const Duration(days: 6)),
    ),
    Task(
      title: 'Tarea 4',
      type: 'normal',
      descripcion: 'Descripción de la tarea 4',
      fecha: DateTime(2024, 4, 10),
      fechalimite: DateTime.now().add(const Duration(days: 3)),
    ),
    Task(
      title: 'Tarea 5',
      type: 'urgente',
      descripcion: 'Descripción de la tarea 5',
      fecha: DateTime(2024, 4, 11),
      fechalimite: DateTime.now().add(const Duration(days: 8)),
    ),
    Task(
      title: 'Tarea 6',
      type: 'urgente',
      descripcion: 'Descripción de la tarea 5',
      fecha: DateTime(2024, 4, 11),
      fechalimite: DateTime.now().add(const Duration(days: 9)),
    ),
  ];


  List<Task> _tasks = List.from(inicial); // Copia de la lista original

  List<Task> getTasks() {
    return List.from(_tasks);
  }

  void addTask(Task task) {
    _tasks.add(task);
    print('Tarea añadida: ${task.title}');
  }

  Task? getTaskById(int index) {
    if (index >= 0 && index < _tasks.length) {
      return _tasks[index];
    }
    return null;
  }

  bool removeTask(int index) {
    if (index < 0 || index >= _tasks.length) {
      _tasks.removeAt(index);
      return true;
    }
    return false; // Eliminar la tarea de la lista
  }

    bool updateTask(int index, Task task) {
    if (index < 0 || index >= _tasks.length) {
      _tasks[index] = task;
      return true;
    }
    return false;
  }


  void resetTasks() {
    _tasks = List.from(inicial); // Restablece la lista a su estado original
  }
}
