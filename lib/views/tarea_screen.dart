import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/tarea/tarea_bloc.dart';
import 'package:mi_proyecto/bloc/tarea/tarea_event.dart';
import 'package:mi_proyecto/bloc/tarea/tarea_state.dart';
import 'package:mi_proyecto/bloc/tarea_contador/tarea_contador_event.dart';
import 'package:mi_proyecto/bloc/tarea_contador/tarea_contador_state.dart';
import 'package:mi_proyecto/components/add_task_modal.dart';
import 'package:mi_proyecto/components/custom_bottom_navigation_bar.dart';
import 'package:mi_proyecto/components/last_updated_header.dart';
import 'package:mi_proyecto/components/side_menu.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/domain/tarea.dart';
import 'package:mi_proyecto/helpers/dialog_helper.dart';
import 'package:mi_proyecto/helpers/snackbar_helper.dart';
import 'package:mi_proyecto/helpers/snackbar_manager.dart';
import 'package:mi_proyecto/helpers/task_card_helper.dart';
import 'package:mi_proyecto/views/tarea_detalles_screen.dart';

import '../bloc/tarea_contador/tarea_contador_bloc.dart';

class TareaScreen extends StatelessWidget {
  const TareaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Limpiar cualquier SnackBar existente al entrar a esta pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!SnackBarManager().isConnectivitySnackBarShowing) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });

    // Cargar las tareas al entrar a la pantalla
    context.read<TareaBloc>().add(LoadTareasEvent());

    return MultiBlocProvider(
      providers: [
        BlocProvider<TareaContadorBloc>(
          create: (context) => TareaContadorBloc(),
        ),
        BlocProvider.value(
          value: context.read<TareaBloc>(),
        ),
      ],
      child: BlocListener<TareaBloc, TareaState>(
        listener: (context, state) {
          if (state is TareaCompletada) {
            if (state.isCompleted) {
              context.read<TareaContadorBloc>().add(TareaContadorIncrementEvent());
            } else {
              context.read<TareaContadorBloc>().add(TareaContadorDecrementEvent());
            }
          } else if (state is TareaLoaded) {
            // Inicializar contador con estado actual
            int tareasCompletadas = state.tareas.where((t) => t.isCompleted).length;
            context.read<TareaContadorBloc>().add(
              TareaContadorResetEvent(
                total: state.tareas.length,
                completadas: tareasCompletadas,
              ),
            );
          }
        },
        child: const _TareaScreenContent(),
      ),
    );
  }
}

class _TareaScreenContent extends StatefulWidget {
  const _TareaScreenContent();

  @override
  _TareaScreenContentState createState() => _TareaScreenContentState();
}

class _TareaScreenContentState extends State<_TareaScreenContent> {
  final ScrollController _scrollController = ScrollController();
  static const int _limitePorPagina = 5;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<TareaBloc>().state;
      if (state is TareaLoaded && state.hayMasTareas) {
        context.read<TareaBloc>().add(
          LoadMoreTareasEvent(
            pagina: state.paginaActual + 1,
            limite: _limitePorPagina,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TareaBloc, TareaState>(
      listener: (context, state) {
        if (state is TareaError) {
          SnackBarHelper.manejarError(context, state.error);
        } else if (state is TareaOperationSuccess) {
          SnackBarHelper.mostrarExito(context, mensaje: state.mensaje);
        }
      },
      builder: (context, state) {
        DateTime? lastUpdated;
        if (state is TareaLoaded) {
          lastUpdated = state.lastUpdated;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              state is TareaLoaded
                  ? '${TareasConstantes.tituloAppBar} - Total: ${state.tareas.length}'
                  : TareasConstantes.tituloAppBar,
            ),
            centerTitle: true,
          ),
          drawer: const SideMenu(),
          backgroundColor: Colors.grey[200],
          body: Column(
            children: [
              LastUpdatedHeader(lastUpdated: lastUpdated),
              Expanded(child: _construirCuerpoTareas(context, state)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _mostrarModalAgregarTarea(context),
            tooltip: 'Agregar Tarea',
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: const CustomBottomNavigationBar(
            selectedIndex: 0,
          ),
        );
      },
    );
  }

  Widget _construirCuerpoTareas(BuildContext context, TareaState state) {
    if (state is TareaInitial || (state is TareaLoading && state is! TareaLoaded)) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is TareaError && state is! TareaLoaded) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.error.message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<TareaBloc>().add(LoadTareasEvent()),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state is TareaLoaded) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<TareaBloc>().add(LoadTareasEvent(forzarRecarga: true));
        },
        child: Column(
          children: [
            // Indicador de progreso
            const TareaProgressIndicator(),

            // Lista de tareas
            Expanded(
              child: state.tareas.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: const Center(
                            child: Text(TareasConstantes.listaVacia),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.tareas.length + (state.hayMasTareas ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.tareas.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final tarea = state.tareas[index];
                        return Dismissible(
                          key: Key(tarea.id.toString()),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.startToEnd,
                          confirmDismiss: (direction) async {
                            return await DialogHelper.mostrarConfirmacion(
                              context: context,
                              titulo: 'Confirmar eliminación',
                              mensaje: '¿Estás seguro de que deseas eliminar esta tarea?',
                              textoCancelar: 'Cancelar',
                              textoConfirmar: 'Eliminar',
                            );
                          },
                          onDismissed: (_) {
                            context.read<TareaBloc>().add(DeleteTareaEvent(tarea.id!));
                          },
                          child: GestureDetector(
                            onTap: () => _mostrarDetallesTarea(context, index, state.tareas),
                            child: _construirTarjetaTarea(
                              context,
                              tarea,
                              () => _mostrarModalEditarTarea(context, tarea),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _mostrarDetallesTarea(BuildContext context, int indice, List<Tarea> tareas) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(
          tareas: tareas,
          indice: indice,
        ),
      ),
    );
  }

  void _mostrarModalEditarTarea(BuildContext context, Tarea tarea) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AddTaskModal(
        taskToEdit: tarea,
        onTaskAdded: (Tarea tareaEditada) {
          context.read<TareaBloc>().add(UpdateTareaEvent(tareaEditada));
        },
      ),
    );
  }

  void _mostrarModalAgregarTarea(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AddTaskModal(
        onTaskAdded: (Tarea nuevaTarea) {
          context.read<TareaBloc>().add(CreateTareaEvent(nuevaTarea));
        },
      ),
    );
  }

  // Nuevo método para construir la tarjeta con checkbox
  Widget _construirTarjetaTarea(
    BuildContext context,
    Tarea tarea,
    VoidCallback onEdit,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Checkbox para marcar como completada
            Checkbox(
              value: tarea.isCompleted,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (value) {
                context.read<TareaBloc>().add(
                  ToggleCompletadoTareaEvent(
                    id: tarea.id!,
                    isCompleted: value ?? false,
                  ),
                );
              },
            ),

            // Contenido principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tarea.titulo,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: tarea.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: tarea.isCompleted ? Colors.grey : Colors.black,
                    ),
                  ),
                  if (tarea.descripcion != null)
                    Text(
                      tarea.descripcion!,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Row(
                    children: [
                      Icon(
                        tarea.tipo == 'normal' ? Icons.task : Icons.warning,
                        color: tarea.tipo == 'normal' ? Colors.blue : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${TareasConstantes.tipoTarea}${tarea.tipo}',
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      if (tarea.fechaLimite != null) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: _esFechaVencida(tarea.fechaLimite!)
                              ? Colors.red
                              : Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${tarea.fechaLimite!.day}/${tarea.fechaLimite!.month}/${tarea.fechaLimite!.year}',
                          style: TextStyle(
                            fontSize: 12,
                            color: _esFechaVencida(tarea.fechaLimite!)
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Botón de editar
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para verificar si una fecha está vencida
  bool _esFechaVencida(DateTime fecha) {
    return fecha.isBefore(DateTime.now());
  }
}

class TareaProgressIndicator extends StatelessWidget {
  const TareaProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TareaContadorBloc, TareaContadorState>(
      builder: (context, state) {
        // Siempre mostrar el indicador, incluso si no hay tareas
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila para mostrar el texto informativo y el porcentaje
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
              // Barra de progreso con estilo visual mejorado
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: LinearProgressIndicator(
                  value: state.porcentajeCompletado,
                  minHeight: 10.0,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressColor(context, state.porcentajeCompletado),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              // Mensaje motivacional basado en el progreso
              Text(
                _getMensajeMotivacional(state.porcentajeCompletado),
                style: TextStyle(
                  fontSize: 14.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Método para determinar el color de la barra de progreso
  Color _getProgressColor(BuildContext context, double porcentaje) {
    if (porcentaje >= 0.8) {
      return Colors.green;
    } else if (porcentaje >= 0.5) {
      return Theme.of(context).primaryColor;
    } else if (porcentaje >= 0.2) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
  
  // Método para obtener un mensaje motivacional basado en el progreso
  String _getMensajeMotivacional(double porcentaje) {
    if (porcentaje >= 0.9) {
      return '¡Excelente! Casi has completado todas tus tareas.';
    } else if (porcentaje >= 0.7) {
      return '¡Buen progreso! Ya llevas más de dos tercios completados.';
    } else if (porcentaje >= 0.4) {
      return '¡Vas bien! Continúa así para completar todas tus tareas.';
    } else if (porcentaje > 0) {
      return '¡Ánimo! Has comenzado bien, sigue adelante.';
    } else {
      return 'Sin tareas completadas. ¡Es hora de comenzar!';
    }
  }
}
