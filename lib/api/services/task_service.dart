//import 'dart:async';

import 'package:mi_proyecto/data/task_repository.dart';
import 'package:mi_proyecto/domain/task.dart';
import 'package:mi_proyecto/data/assistant_repository.dart';
import 'package:mi_proyecto/constants.dart';

class TaskService {
  final TaskRepository _taskRepository = TaskRepository();
  final AssistantRepository _assistantRepository = AssistantRepository();




  // Obtener todas las tareas
  // List<Task> getTasksWithSteps(String titulo, DateTime fechalimite) {
  //   try {
  //     List<String> pasosSimulados = _assistantRepository.obtenerPasos(titulo, fechaString).take(LIMITE_PASOS).toList(); // Limita los pasos simulados obtenidos
  //    _taskRepository.setListaPasos(pasosSimulados); // Establece la lista de pasos en el repositorio
  //    return pasosSimulados; 
  //   } catch (e) {
  //     throw Exception('Error al obtener tareas: $e');
  //   }
  // }

  void _inicializarPasos(List<Task> tasks) {
    for (Task task in tasks) {
      if (task.getPasos == null || task.getPasos!.isEmpty) {
        //for (String paso in _assistantRepository.getListaPasos()
        getTasksWithSteps(task.getTitle, task.getFechalimite);
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

  List<Task> getTasks() {
     print('Obteniendo tareas'); 
     List<Task> tasks = _taskRepository.getTasks();
     _inicializarPasos(tasks);
     return tasks;
   }

  // Eliminar una tarea
  void eliminarTarea(int index) {
    try {
      _taskRepository.deleteTask(index);
      print('$tarea_eliminada $index');
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
  List<String> getTasksWithSteps(String titulo, DateTime fechalimite) {
    try {
      String fechaString =
          '${fechalimite.day}/${fechalimite.month}/${fechalimite.year}';
      List<String> pasosSimulados = _assistantRepository.obtenerPasos(titulo, fechaString).take(2).toList(); // Limita los pasos simulados obtenidos
     _taskRepository.setListaPasos(pasosSimulados); 
     return pasosSimulados;
    } catch (e) {
      throw Exception('Error al obtener pasos: $e');
    }
  }

  // cargar mas tareas
  List<Task> loadMoreTasks(int nextTaskId, int count) {
    try {
      List<Task> newTask = List.generate(
        count,
        (index) => Task(
          title: 'Tarea ${nextTaskId + index}',
          type:
              ( index % 2) == 0
                  ? task_type_nomal
                  : task_type_urgent,
          descripcion: 'Descripción de tarea ${nextTaskId + index}',
          fecha: DateTime.now().add(Duration(days: index)),
          //deadline: DateTime.now().add(Duration(days: index + 1)),
          deadline: DateTime.now().add(Duration(days: 1)),
          steps: TaskService().getTasksWithSteps(
            'Tarea ${nextTaskId + index}',
            DateTime.now().add(Duration(days: index + 1)),
          ),
        ),
      );
      _updateTaskList(newTask);
      return newTask;
    } catch (e) {
      throw Exception('Error al obtener más tareas: $e');
    }
  }

 void _updateTaskList (List<Task> tasks) {
     for (Task task in tasks) {
       _taskRepository.addTask(task);
     } 
   }

}
 
