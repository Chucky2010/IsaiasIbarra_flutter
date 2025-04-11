import 'package:flutter/material.dart';
import 'package:mi_proyecto/constants.dart';
import 'package:mi_proyecto/domain/task.dart';
//import 'package:mi_proyecto/api/service/tareas_service.dart';

class TaskCardHelper {
  static Widget buildTaskCard(
    List<Task> tasks,
    Task task, 
    BuildContext context,
    int index, {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(TAREA_ELIMINADA)),
        );
      },


//       child: ListTile(
//           title: Text(
//             task.title,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//       subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
             
//                 task.type == TASK_TYPE_URGENT ? 
//                 const Icon(Icons.warning, color: Colors.red,)
//                 :
//                 task.type == TASK_TYPE_NORMAL ? 
//                 const Icon(Icons.task, color: Colors.blue,)
                
//                 :
                
//               const SizedBox(width: 4),
//               Text(
//                 '$TIPO_TAREA ${task.type}',
//                   style: TextStyle(
//                   color: task.type == TASK_TYPE_URGENT ? Colors.red : Colors.blue,
//                 ),
//               ),
//             const SizedBox(width: 16),
//             Text(
//               task.fechaToString(),
//               style: const TextStyle(color: Colors.grey),
//             ),
//           ],
//         ),
//           if (task.steps != null && task.steps!.isNotEmpty)
//           Text('$PASOS_TITULO ${task.getPasos![0]}'),
//       ],//children
//     ),  
//   trailing: Row(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       IconButton(
//         icon: const Icon(Icons.edit),
//         onPressed: onEdit,
//       ),
//       IconButton(
//         icon: const Icon(Icons.delete),
//         onPressed: onDelete,
//       ),
//     ],
//   ),
// ),
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
              if (task.steps != null && task.steps!.isNotEmpty)
               Text(
                 task.getPasos![0],
                 style: const TextStyle(color: Colors.grey),
               ),
              const SizedBox(height: 8),
              Text(task.descripcion),
              const SizedBox(height: 8),
              Row(
                children: [
                  
                  Icon(
                    task.type == TASK_TYPE_URGENT ? Icons.warning : Icons.task,
                    color: task.type == TASK_TYPE_URGENT ? Colors.red : Colors.blue,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$TIPO_TAREA ${task.type}',
                    style: TextStyle(
                    color: task.type == TASK_TYPE_URGENT ? Colors.red : Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    task.fechaToString(),
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


}