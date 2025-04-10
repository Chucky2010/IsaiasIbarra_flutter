import 'package:flutter/material.dart';
import 'package:mi_proyecto/helpers/task_card_helper.dart';
import 'package:mi_proyecto/domain/task.dart';
import 'package:mi_proyecto/constants.dart';

class SportsCardScreen extends StatelessWidget {
  final List<Task> tasks;
  final int initialIndex;

  const SportsCardScreen({
    super.key,
    required this.tasks,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: buildSportsCard(tasks[index], context),
          );
        },
      ),
    );
  }

  Widget buildSportsCard(Task task, BuildContext context) {
    //final pasos = TareasService().obtenerPasos(task.title, task.fechalimite);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20), // Imagen aleatoria
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Image.network(
                'https://picsum.photos/200/300?random=${task.title.hashCode}',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
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
                // if (pasos.isNotEmpty)
                //   Text(
                //     pasos.take(6).join('\n'),
                //     style: const TextStyle(color: Colors.grey),
                //     maxLines: 6,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                for (String paso in task.getPasos!) // Itera sobre los pasos
                   Text(
                     paso,
                     style: const TextStyle(
                       fontSize: 15,
                     ),
                   ),
                const SizedBox(height: 8),
                // Fecha límite
                // Text(
                //   '$FECHA_LIMITE ${task.fechalimite.toLocal().toString().split(' ')[0]}',

                //   style: const TextStyle(
                //     color: Colors.grey,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                Text(
                   FECHA_LIMITE + task.fechaLimiteToString(),
                   style: const TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 const SizedBox(height: 8),
                 // Descripción
                 Text(
                   TASK_DESCRIPTION,
                   style: const TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 const SizedBox(height: 8),
                 Text(task.getDescription),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
