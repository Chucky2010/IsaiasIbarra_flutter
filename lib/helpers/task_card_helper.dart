import 'package:flutter/material.dart';
import 'package:mi_proyecto/constants.dart';
import 'package:mi_proyecto/domain/task.dart';
//import 'package:mi_proyecto/api/service/tareas_service.dart';

class TaskCardHelper {
  static Widget buildTaskCard(
    Task task,  {
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    
  }) {
    return Dismissible(
      key: Key(task.title),
      background: Container(
        alignment: Alignment.centerLeft,
        color: Colors.red,
        child: Icon(Icons.delete),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (rigth) {
        onDelete();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("${task.title} eliminada")),
        // );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (task.pasos != null && task.pasos!.isNotEmpty)
               Text(
                 task.pasos!.first,
                 style: const TextStyle(color: Colors.grey),
               ),
              const SizedBox(height: 8),
              Text(task.descripcion),
              const SizedBox(height: 8),
              Row(
                children: [
                  
                  Icon(
                    task.type == 'urgente' ? Icons.warning : Icons.task,
                    color: task.type == 'urgente' ? Colors.red : Colors.blue,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Tipo: ${task.type}',
                    style: TextStyle(
                      color: task.type == 'urgente' ? Colors.red : Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    task.fecha.toLocal().toString().split(' ')[0],
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
static Widget buildSportsCard(Task task, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen aleatoria
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
            child: Image.network(
              'https://picsum.photos/200/300?random=$index',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Pasos (máximo 3 líneas)
                if (task.pasos != null && task.pasos!.isNotEmpty)
                  Text(
                    task.pasos!.take(3).join('\n'),
                    style: const TextStyle(color: Colors.grey),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                // Fecha límite
                Text(
                  '$FECHA_LIMITE ${task.fechalimite.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}