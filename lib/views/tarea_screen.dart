import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/tarea/tarea_bloc.dart';
import 'package:mi_proyecto/bloc/tarea/tarea_event.dart';
import 'package:mi_proyecto/bloc/tarea/tarea_state.dart';
import 'package:mi_proyecto/bloc/tarea_contador/tarea_contador_bloc.dart';
import 'package:mi_proyecto/bloc/tarea_contador/tarea_contador_event.dart';
import 'package:mi_proyecto/components/add_task_modal.dart';
import 'package:mi_proyecto/components/custom_bottom_navigation_bar.dart';
import 'package:mi_proyecto/components/last_updated_header.dart';
import 'package:mi_proyecto/components/side_menu.dart';
import 'package:mi_proyecto/components/tarea_progreso_indicator.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/domain/tarea.dart';
import 'package:mi_proyecto/helpers/dialog_helper.dart';
import 'package:mi_proyecto/helpers/snackbar_helper.dart';
import 'package:mi_proyecto/views/tarea_detalles_screen.dart';

class TareaScreen extends StatelessWidget {
  const TareaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TareaBloc>(
          create: (context) => TareaBloc()..add(LoadTareasEvent()),
        ),
        BlocProvider<TareaContadorBloc>(
          create: (context) => TareaContadorBloc(),
        ),
      ],
      child: const _TareaScreenContent(),
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
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
        } else if (state is TareaCompletada) {
          // Actualizamos el contador solo una vez aquí
          if (state.completada) {
            context.read<TareaContadorBloc>().add(IncrementarContador());
          } else {
            context.read<TareaContadorBloc>().add(DecrementarContador());
          }
          // Mostramos el snackbar
          SnackBarHelper.mostrarExito(
            context,
            mensaje:
                state.completada
                    ? 'Tarea completada exitosamente'
                    : 'Tarea marcada como pendiente',
          );
        } else if (state is TareaLoaded) {
          // Actualizamos primero el total y luego las completadas
          final totalCompletadas =
              state.tareas.where((t) => t.completado).length;
          final tareaContadorBloc = context.read<TareaContadorBloc>();

          // Establecemos el total de tareas
          tareaContadorBloc.add(SetTotalTareas(state.tareas.length));

          // Establecemos las completadas usando un nuevo evento
          tareaContadorBloc.add(SetCompletadas(totalCompletadas));
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
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Recargar tareas',
                onPressed: () {
                  // Forzamos la recarga desde la API
                  context.read<TareaBloc>().add(
                    LoadTareasEvent(forzarRecarga: true),
                  );

                  // Opcional: Mostrar un SnackBar para indicar la recarga
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Recargando tareas...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),          drawer: const SideMenu(),
          body: Column(
            children: [
              LastUpdatedHeader(lastUpdated: lastUpdated),
              if (state is TareaLoaded) const TareaProgresoIndicator(),
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
    // Envolvemos todo el contenido en un RefreshIndicator
    return RefreshIndicator(
      onRefresh: () async {
        // Forzamos la recarga desde la API
        context.read<TareaBloc>().add(LoadTareasEvent(forzarRecarga: true));
      },
      child: _construirContenidoTareas(context, state),
    );
  }

  // Nuevo método para el contenido
  Widget _construirContenidoTareas(BuildContext context, TareaState state) {    if (state is TareaInitial || state is TareaLoading) {
      final theme = Theme.of(context);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: theme.colorScheme.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Cargando tareas...',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.brightness == Brightness.dark
                    ? theme.colorScheme.onSurface.withOpacity(0.9)
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    if (state is TareaError && state is! TareaLoaded) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,              children: [
                Text(
                  state.error.message,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => context.read<TareaBloc>().add(LoadTareasEvent()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (state is TareaLoaded) {      final theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;
      
      return state.tareas.isEmpty          
          ? ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 48,
                        color: isDark
                            ? theme.colorScheme.primary.withOpacity(0.7)
                            : theme.colorScheme.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        TareasConstantes.listaVacia,
                        style: TextStyle(
                          color: isDark
                              ? theme.colorScheme.onSurface.withOpacity(0.8)
                              : theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
          : ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: state.tareas.length + (state.hayMasTareas ? 1 : 0),
            itemBuilder: (context, index) {              if (index == state.tareas.length) {
                final theme = Theme.of(context);
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? theme.colorScheme.surface.withOpacity(0.3)
                        : theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                      strokeWidth: 3,
                    ),
                  ),
                );
              }

              final tarea = state.tareas[index];              return Dismissible(
                key: Key(tarea.id.toString()),
                background: Container(
                  color: Theme.of(context).colorScheme.error,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
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
                  onTap:
                      () => _mostrarDetallesTarea(context, index, state.tareas),
                  child: construirTarjetaDeportiva(
                    tarea,
                    tarea.id!,
                    () => _mostrarModalEditarTarea(context, tarea),
                    (completado) {
                      context.read<TareaBloc>().add(
                        UpdateTareaEvent(
                          tarea.copyWith(completado: completado),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
    }

    return const SizedBox.shrink();
  }

  void _mostrarDetallesTarea(
    BuildContext context,
    int indice,
    List<Tarea> tareas,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(tareas: tareas, indice: indice),
      ),
    );
  }

  void _mostrarModalEditarTarea(BuildContext context, Tarea tarea) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => AddTaskModal(
            taskToEdit: tarea,
            onTaskAdded: (Tarea tareaEditada) {
              context.read<TareaBloc>().add(UpdateTareaEvent(tareaEditada));
            },
          ),
    );
  }

  void _mostrarModalAgregarTarea(BuildContext context) {
    // Obtener el estado actual del BLoC
    final state = context.read<TareaBloc>().state;
    
    // Verificar si ya hay 3 tareas
    if (state is TareaLoaded && state.tareas.length >= 3) {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No puedes crear más de 3 tareas.'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Entendido',
            textColor: Theme.of(context).colorScheme.onError,
            onPressed: () {},
          ),
        ),
      );
      return; // Salir del método sin mostrar el modal
    }
    
    // Si no se ha alcanzado el límite, mostrar el diálogo normalmente
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
  // Actualizar el método construirTarjetaDeportiva
  Widget construirTarjetaDeportiva(
    Tarea tarea,
    String s,
    void Function() param2,
    Null Function(dynamic completado) param3,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
      return Card(
      elevation: isDark ? 0 : 2, // Sin elevación en modo oscuro para evitar sombras confusas
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isDark 
              ? theme.colorScheme.outline.withOpacity(0.4) // Mayor opacidad para mejor contraste
              : theme.colorScheme.outline.withOpacity(0.1),
          width: isDark ? 1.0 : 0.5, // Borde más grueso en modo oscuro
        ),
      ),
      color: isDark 
          ? theme.cardTheme.color?.withOpacity(0.9) // Ajuste para mejor visualización
          : theme.cardTheme.color,
      child: ListTile(
        leading: Checkbox(
          value: tarea.completado,
          activeColor: theme.colorScheme.primary,
          checkColor: theme.colorScheme.onPrimary,
          onChanged: (bool? value) {
            if (value != null) {
              context.read<TareaBloc>().add(
                CompletarTareaEvent(tarea: tarea, completada: value),
              );
            }
          },
        ),        title: Text(
          tarea.titulo,
          style: TextStyle(
            color: tarea.completado && isDark
                ? theme.textTheme.titleMedium?.color?.withOpacity(0.7)
                : theme.textTheme.titleMedium?.color,
            decoration: tarea.completado ? TextDecoration.lineThrough : null,
            decorationColor: theme.colorScheme.secondary,
            decorationThickness: 2.0,
            fontWeight: tarea.completado ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Text(
          tarea.descripcion ?? '',
          style: TextStyle(
            color: isDark
                ? theme.textTheme.bodyMedium?.color?.withOpacity(0.8) // Mayor opacidad en modo oscuro
                : theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),        trailing: IconButton(
          icon: Icon(
            Icons.edit,
            color: isDark
                ? theme.colorScheme.primary.withOpacity(0.9) // Usa el color primario con alta opacidad
                : theme.colorScheme.secondary,
            size: 22, // Tamaño ligeramente más grande para mejor visibilidad
          ),
          onPressed: () => _mostrarModalEditarTarea(context, tarea),
        ),
      ),
    );
  }
}
