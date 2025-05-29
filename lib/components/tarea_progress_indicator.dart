import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/tarea_contador/tarea_contador_bloc.dart';
import 'package:mi_proyecto/bloc/tarea_contador/tarea_contador_state.dart';

class TareaProgressIndicator extends StatelessWidget {
  const TareaProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TareaContadorBloc, TareaContadorState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${state.completadas}/${state.total} tareas completadas',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    '${(state.porcentajeCompletado * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              LinearProgressIndicator(
                value: state.porcentajeCompletado,
                backgroundColor: Colors.grey[300],
                minHeight: 10,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ],
          ),
        );
      },
    );
  }
}