//import 'package:mi_proyecto/api/service/tareas_service.dart';
import 'package:mi_proyecto/constants.dart';
import 'package:mi_proyecto/api/service/tareas_service.dart';

import '../domain/task.dart';

class TaskRepository {

  // final TareasService _servicio = TareasService();
  // int _contadorTareas = 5;
  //final TareasService _tareasService = TareasService();

   final List<Task> tareas = [
    Task(
      title: 'Tarea 1',
      type: 'urgente',
      descripcion: 'Descripción de la tarea 1',
      fecha: DateTime(2024, 4, 7),
      fechalimite: DateTime.now().add(const Duration(days: 4)),
      pasos: getPasos('Tarea 1', DateTime(2024, 4, 8).add(Duration(days: 1))), // Mock de pasos
    ),
    Task(
      title: 'Tarea 2',
      type: 'normal',
      descripcion: 'Descripción de la tarea 2',
      fecha: DateTime(2024, 4, 8),
      fechalimite: DateTime.now().add(const Duration(days: 4)),
      pasos: getPasos('Tarea 2', DateTime(2024, 4, 8).add(Duration(days: 1))),
    ),
    Task(
      title: 'Tarea 3',
      type: 'urgente',
      descripcion: 'Descripción de la tarea 3',
      fecha: DateTime(2024, 4, 9),
      fechalimite: DateTime.now().add(const Duration(days: 6)),
      pasos: getPasos('Tarea 3', DateTime(2024, 4, 8).add(Duration(days: 1))),
    ),
    Task(
      title: 'Tarea 4',
      type: 'normal',
      descripcion: 'Descripción de la tarea 4',
      fecha: DateTime(2024, 4, 10),
      fechalimite: DateTime.now().add(const Duration(days: 3)),
      pasos: getPasos('Tarea 4', DateTime(2024, 4, 8).add(Duration(days: 1))),// Mock de pasos
    ),
    Task(
      title: 'Tarea 5',
      type: 'urgente',
      descripcion: 'Descripción de la tarea 5',
      fecha: DateTime(2024, 4, 11),
      fechalimite: DateTime.now().add(const Duration(days: 8)),
      pasos: getPasos('Tarea 5', DateTime(2024, 4, 8).add(Duration(days: 1))), // Mock de pasos
    ),
    Task(
      title: 'Tarea 6',
      type: 'urgente',
      descripcion: 'Descripción de la tarea 5',
      fecha: DateTime(2024, 4, 11),
      fechalimite: DateTime.now().add(const Duration(days: 9)),
      pasos: getPasos('Tarea 6', DateTime(2024, 4, 8).add(Duration(days: 1))),// Mock de pasos
    ),
  ];


  //List<Task> _tasks = List.from(inicial); // Copia de la lista original

  List<Task> getTasks() {
    return tareas;
  }

  void addTask(Task tarea) async {
  tareas.add(tarea);
    print('Tarea añadida: ${tarea.title}');
  }

  Task? getTaskById(int index) {
    if (index >= 0 && index < tareas.length) {
      return tareas[index];
    }else
      throw Exception('Índice fuera de rango: $index');
  }

  void removeTask(int index) {
    if (index < 0 || index >= tareas.length) {
      tareas.removeAt(index);
      
    }
  }

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
         pasos: TareasService().obtenerPasos('Tarea ${nextTaskId + index}', DateTime.now().add(Duration(days: index + 1))),
       ),
     );
   }


  // void resetTasks() {
  //   _tasks = List.from(inicial); // Restablece la lista a su estado original
  // }


static List<String> getPasos(String titulo, DateTime fechaLimite) {
    return [
      'Paso 1: Planificar $titulo',
      'Paso 2: Ejecutar $titulo',
      'Paso 3: Revisar $titulo',
    ];
  }


}
