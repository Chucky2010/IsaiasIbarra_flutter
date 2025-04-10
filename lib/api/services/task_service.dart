import 'dart:async';

import 'package:mi_proyecto/data/task_repository.dart';
import 'package:mi_proyecto/domain/task.dart';
import 'package:mi_proyecto/data/assistant_repository.dart';
import 'package:mi_proyecto/constants.dart';

class TaskService {
  final TaskRepository _taskRepository = TaskRepository();
  final AssistantRepository _assistantRepository = AssistantRepository();

// Obtener todas las tareas
  List<Task> getTasksWithSteps() {
    try {
      List<Task> tasks = _taskRepository.getTasks();
      inicializarPasos(tasks);
     return tasks;
    } catch (e) {
      throw Exception('Error al obtener tareas: $e');
    }
  }

   void inicializarPasos(List<Task> tasks) {
    for (Task task in tasks) {
       if (task.getPasos == null || task.getPasos!.isEmpty) {
        //for (String paso in _assistantRepository.getListaPasos()
         for (String paso in _assistantRepository.getListaPasos().take(2)) {
           task.getPasos!.add('$paso${task.getTitle} antes de ${task.fechaLimiteToString()}');
         }
       }
     }

  }

  //crear nueva tarea
  void agregarTarea(Task tarea) {
    try {
      _taskRepository.addTask(tarea);
      print('crea tarea: ${tarea.title}');
    } catch (e) {
      throw Exception('Error al agregar tarea: $e');
    }
  }

  // Eliminar una tarea
  void eliminarTarea(int index) {
    try {
      _taskRepository.deleteTask(index);
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

  // Obtener pasos simulados para una tarea según su título
  List<String> obtenerPasos(String titulo, DateTime fechalimite) {
    try {
      String fechaString = '${fechalimite.day}/${fechalimite.month}/${fechalimite.year}';
      return _assistantRepository.obtenerPasos(titulo, fechaString);
    } catch (e) {
      throw Exception('Error al obtener pasos: $e');
    }
  }

  
  List<Task> obtenerMasTareas(int nextTaskId, int count) {
    try {
      return List.generate(
       count,
       (index) => Task(
         title: 'Tarea ${nextTaskId + index}',
         type: (index % 2) == 0 ? TASK_TYPE_NORMAL : TASK_TYPE_URGENT,
         descripcion: 'Descripción de tarea ${nextTaskId + index}',
         fecha: DateTime.now().add(Duration(days: index)),
         deadline: DateTime.now().add(Duration(days: index + 1)), 
         steps: TaskService().obtenerPasos('Tarea ${nextTaskId + index}', DateTime.now().add(Duration(days: index + 1))),
       ),
     );
    } catch (e) {
      throw Exception('Error al obtener más tareas: $e');
    }
  }
  
 
}
