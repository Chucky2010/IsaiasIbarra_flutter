import 'package:flutter/material.dart';
import 'package:mi_proyecto/helpers/common_widgets_helper.dart';
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
      appBar: AppBar(
        title: const Text('Tareas'),
        backgroundColor: Colors.pinkAccent,
      ),
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
      shape: CommonWidgetsHelper.buildRoundedBorder(),//borde redondeado
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16), // Imagen aleatoria
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
                 // Título
                CommonWidgetsHelper.buildBoldTitle(task.title),
                CommonWidgetsHelper.buildSpacing(), // Espaciado
                const SizedBox(height: 8),
                // Pasos (máximo 3 líneas)
                // if (pasos.isNotEmpty)
                //   Text(
                //     pasos.take(6).join('\n'),
                //     style: const TextStyle(color: Colors.grey),
                //     maxLines: 6,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                if (task.getPasos != null && task.getPasos!.isNotEmpty)
                  CommonWidgetsHelper.buildInfoLines(
                    firstLine: task.getPasos![0], // Primer paso obligatorio
                    secondLine: task.getPasos!.length > 1 ? task.getPasos![1] : null, // Segundo paso opcional
                    thirdLine: task.getPasos!.length > 2 ? task.getPasos![2] : null, // Tercer paso opcional
                  ),
                  CommonWidgetsHelper.buildSpacing(),
          
                // Fecha límite
                CommonWidgetsHelper.buildBoldFooter(
                  '$AppConstants.fechaLimite ${task.fechaLimiteToString()}',
                ),
                CommonWidgetsHelper.buildSpacing(), // Espaciado
                 // Descripción
                 CommonWidgetsHelper.buildBoldFooter(AppConstants.taskDescription),
                CommonWidgetsHelper.buildSpacing(), // Espaciado
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
