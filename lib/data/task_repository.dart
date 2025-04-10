//import 'package:mi_proyecto/api/service/tareas_service.dart';
import 'package:mi_proyecto/constants.dart';
import 'package:mi_proyecto/api/service/tareas_service.dart';

import '../domain/task.dart';

class TaskRepository {
  final List<Task> tareas;

  TaskRepository() : tareas = [] {
    tareas.addAll([
      Task(
        title: 'Tarea 1',
        type: 'urgente',
        descripcion: 'Descripción de la tarea 1',
        fecha: DateTime(2024, 4, 7),
        fechalimite: DateTime.now().add(const Duration(days: 4)),
        pasos: [],
      ),

      Task(
        title: 'Tarea 2',
        type: 'normal',
        descripcion: 'Descripción de la tarea 2',
        fecha: DateTime(2024, 4, 8),
        fechalimite: DateTime.now().add(const Duration(days: 4)),
        pasos: [],
      ),
      Task(
        title: 'Tarea 3',
        type: 'urgente',
        descripcion: 'Descripción de la tarea 3',
        fecha: DateTime(2024, 4, 9),
        fechalimite: DateTime.now().add(const Duration(days: 6)),
        pasos: [],
      ),
      Task(
        title: 'Tarea 4',
        type: 'normal',
        descripcion: 'Descripción de la tarea 4',
        fecha: DateTime(2024, 4, 10),
        fechalimite: DateTime.now().add(const Duration(days: 3)),
        pasos: [],
      ),
      Task(
        title: 'Tarea 5',
        type: 'urgente',
        descripcion: 'Descripción de la tarea 5',
        fecha: DateTime(2024, 4, 11),
        fechalimite: DateTime.now().add(const Duration(days: 8)),
        pasos: [],
        // Mock de pasos
      ),
      Task(
        title: 'Tarea 6',
        type: 'urgente',
        descripcion: 'Descripción de la tarea 5',
        fecha: DateTime(2024, 4, 11),
        fechalimite: DateTime.now().add(const Duration(days: 9)),
        pasos: [],
      ), // Mock de pasos
    ]);
  }

  //List<Task> _tasks = List.from(inicial); // Copia de la lista original

  List<Task> getTasks() {
    return tareas;
  }

// agregar tarea
  void addTask(Task tarea) async {
    tareas.add(tarea);
    print('Tarea añadida: ${tarea.title}');
  }

  Task? getTaskById(int index) {
    if (index >= 0 && index < tareas.length) {
      return tareas[index];
    } else
      throw Exception('Índice fuera de rango: $index');
  }
// elimina tarea
  void deleteTask(int index) {
    if (index < 0 || index >= tareas.length) {
      tareas.removeAt(index);
    }
  }
// actualiza tarea
  void updateTask(int index, Task task) async {
    if (index >= 0 && index < tareas.length) {
      // Actualiza los pasos personalizados al modificar la tarea

      tareas[index] = task;
    }
  }

  List<Task> loadMoreTasks(int nextTaskId, int count) {
    return List.generate(
      count,
      (index) => Task(
        title: 'Tarea ${nextTaskId + index}',
        type: (index % 2) == 0 ? TASK_TYPE_NORMAL : 'urgente',
        descripcion: 'Descripción de tarea ${nextTaskId + index}',
        fecha: DateTime.now().add(Duration(days: index)),
        fechalimite: DateTime.now().add(Duration(days: index + 1)),
        pasos: TareasService().obtenerPasos(
          'Tarea ${nextTaskId + index}',
          DateTime.now().add(Duration(days: index + 1)),
        ),
      ),
    );
  }

  // void resetTasks() {
  //   _tasks = List.from(inicial); // Restablece la lista a su estado original
  // }

  // Obtener pasos simulados para una tarea según su título
   List<String> getPasos(String titulo, DateTime fechalimite) {
    String fechaString = '${fechalimite.day}/${fechalimite.month}/${fechalimite.year}';
    
    return [
        'Paso 1: Planificar $titulo antes de $fechaString',
        'Paso 2: Ejecutar $titulo antes de $fechaString',
        'Paso 1: Revisar $titulo antes de $fechaString',
    ];
  }
}
