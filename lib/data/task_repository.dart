import '../domain/task.dart';

class TaskRepository {
  final List<Task> _tasks = [
    Task(title: 'Tarea 1', type: 'normal'),
    Task(title:'Tarea 2', type: 'normal'),
    Task(title:'Tarea 3', type: 'normal'),
    Task(title:'Tarea 4', type: 'urgente'),
    Task(title:'Tarea 5', type: 'urgente'),
  ];

  List<Task> getTasks() {
    return _tasks;
  }

void addTask(Task task) {
    _tasks.add(task);
    print('Tarea añadida: ${task.title}');
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
     print('Tarea eliminada: ${index}');
  }
}

