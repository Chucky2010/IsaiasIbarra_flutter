import 'package:flutter/material.dart';
import 'package:mi_proyecto/helpers/task_card_helper.dart';
import 'package:mi_proyecto/domain/task.dart';

class SportsCardScreen extends StatelessWidget {
  final Task task;
  final int index;

  const SportsCardScreen({
    Key? key,
    required this.task,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarjeta Deportiva'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: TaskCardHelper.buildSportsCard(task, index), // Llama al método buildSportsCard
      ),
    );
  }
}