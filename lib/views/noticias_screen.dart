import 'package:mi_proyecto/bloc/comentarios/comentario_bloc.dart';
import 'package:mi_proyecto/bloc/comentarios/comentario_event.dart';
import 'package:mi_proyecto/bloc/reportes/reportes_bloc.dart';
import 'package:mi_proyecto/bloc/reportes/reportes_event.dart';
import 'package:mi_proyecto/bloc/reportes/reportes_state.dart';
import 'package:mi_proyecto/domain/reporte.dart';
import 'package:mi_proyecto/helpers/category_helper.dart';
import 'package:mi_proyecto/views/comentarios/comentarios_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_proyecto/bloc/bloc%20noticias/noticias_event.dart';
import 'package:mi_proyecto/bloc/bloc%20noticias/noticias_state.dart';
import 'package:mi_proyecto/bloc/bloc%20noticias/noticias_bloc.dart';
import 'package:mi_proyecto/bloc/preferencia/preferencia_bloc.dart';
import 'package:mi_proyecto/bloc/preferencia/preferencia_event.dart';
import 'package:mi_proyecto/components/noticia_dialogs.dart';
import 'package:mi_proyecto/domain/noticia.dart';
import 'package:mi_proyecto/constants.dart';
import 'package:mi_proyecto/helpers/noticia_card_helper.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';
import 'package:mi_proyecto/helpers/error_helper.dart';
import 'package:mi_proyecto/views/category_screen.dart';
import 'package:mi_proyecto/views/preferencia_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/helpers/snackbar_helper.dart';
import 'package:watch_it/watch_it.dart';
class NoticiaScreen extends StatelessWidget {
  const NoticiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NoticiasBloc()..add(const FetchNoticias()),
        ),
        BlocProvider(
          create:
              (context) => PreferenciaBloc()..add(const CargarPreferencias()),
        ),
        // Asegurarnos de usar el BLoC global    
        BlocProvider.value(value: context.read<ComentarioBloc>()),
      ],
      child: BlocConsumer<NoticiasBloc, NoticiasState>(
        listener: (context, state) {
          if (state is NoticiasError) {
            _mostrarError(context, state.statusCode);
          }
        },
        builder: (context, state) {
          // Acceder al estado de preferencias para mostrar información de filtros
          final preferenciaState = context.watch<PreferenciaBloc>().state;
          final filtrosActivos =
              preferenciaState.categoriasSeleccionadas.isNotEmpty;

          return Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    NoticiaConstantes.tituloApp,
                    style: TextStyle(color: Colors.white),
                  ),
                  if (state
                      is NoticiasLoaded) // Check if state is NoticiasLoaded before accessing lastUpdated
                    Text(
                      'Última actualización: ${(DateFormat(NoticiaConstantes.formatoFecha)).format(state.lastUpdated)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
              backgroundColor: const Color.fromARGB(255, 248, 174, 206),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Agregar Noticia',
                  onPressed: () async {                    try {
                      await NoticiaModal.mostrarModal(
                        context: context,
                        noticia: null,
                        onSave: (_, noticiaActualizada) {
                          // Para el caso de crear, simplemente recargamos las noticias
                          context.read<NoticiasBloc>().add(
                            const FetchNoticias(),
                          );
                          SnackBarHelper.showSnackBar(
                            context,
                            ApiConstantes.newssuccessCreated,
                            statusCode: 200,
                          );
                        },
                      );
                      if (!context.mounted) return;
                    } catch (e) {
                      if (e is ApiException) {
                        _mostrarError(context, e.statusCode);
                      }
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.category),
                  tooltip: 'Categorías',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoryScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: filtrosActivos ? Colors.amber : null,
                  ),
                  tooltip: 'Preferencias',
                  onPressed: () {
                    Navigator.push<List<String>>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PreferenciasScreen(),
                      ),
                    ).then((categoriasSeleccionadas) {
                      if (!context.mounted) return;
                      if (categoriasSeleccionadas != null) {
                        if (categoriasSeleccionadas.isNotEmpty) {
                          // Si hay categorías seleccionadas, aplicar filtro
                          context.read<NoticiasBloc>().add(
                            FilterNoticiasByPreferencias(
                              categoriasSeleccionadas,
                            ),
                          );
                        } else {
                          // Si la lista está vacía, usar el evento FetchNoticias para mostrar todas
                          context.read<NoticiasBloc>().add(
                            const FetchNoticias(),
                          );
                        }
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refrescar',
                  onPressed: () {
                    // Al refrescar, aplicar los filtros actuales si existen
                    final categoriasSeleccionadas =
                        context
                            .read<PreferenciaBloc>()
                            .state
                            .categoriasSeleccionadas;
                    if (categoriasSeleccionadas.isNotEmpty) {
                      context.read<NoticiasBloc>().add(
                        FilterNoticiasByPreferencias(categoriasSeleccionadas),
                      );
                    } else {
                      context.read<NoticiasBloc>().add(const FetchNoticias());
                      CategoryHelper.refreshCategories();
                    }
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                // Chip para mostrar filtros activos
                if (filtrosActivos)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    color: Colors.grey[300],
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Filtrado por ${preferenciaState.categoriasSeleccionadas.length} categorías',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Limpiar filtros y mostrar todas las noticias
                            context.read<PreferenciaBloc>().add(
                              const ReiniciarFiltros(),
                            );
                            context.read<NoticiasBloc>().add(
                              const FetchNoticias(),
                            );
                            SnackBarHelper.showSnackBar(
                              context,
                              'Filtros reiniciados.',
                              statusCode: 200,
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              'Limpiar filtros',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(child: _buildBody(state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(NoticiasState state) {
    if (state is NoticiasLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NoticiasLoaded) {
      final noticias = state.noticiasList;
      if (noticias.isEmpty) {
        return const Center(child: Text(NoticiaConstantes.listaVacia));
      } else {
        return ListView.separated(
          itemCount: noticias.length,
          itemBuilder: (context, index) {
            final noticia = noticias[index];
            return NoticiaCardHelper.buildNoticiaCard(
              noticia: noticia,
              onEdit: () async {
                try {
                  await _editarNoticia(context, noticia);
                } catch (e) {
                  if (e is ApiException) {
                    if (!context.mounted) return;
                    _mostrarError(context, e.statusCode);
                  }
                }
              },
              onReport: () async {
                // Mostrar diálogo de reporte
                await _mostrarDialogoReporte(context, noticia.id!);
              },
              onDelete: () async {
                final confirmacion = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Eliminar Noticia'),
                      content: const Text(
                        '¿Estás seguro de que deseas eliminar esta noticia? Esta acción no se puede deshacer.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    );
                  },
                );

                if (confirmacion == true) {
                  try {
                    if (!context.mounted) return;
                    context.read<NoticiasBloc>().add(
                      DeleteNoticia(noticia.id!),
                    );
                    SnackBarHelper.showSnackBar(
                      context,
                      ApiConstantes.newssuccessDeleted,
                      statusCode: 200,
                    );
                  } catch (e) {
                    if (e is ApiException) {
                      if (!context.mounted) return;
                      _mostrarError(context, e.statusCode);
                    }
                  }
                }
              },
              onComment: () async {
                // Abrir el diálogo de comentarios
                if (!context.mounted) return;

                // Mostrar el diálogo de comentarios
                await Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                ComentariosScreen(noticiaId: noticia.id!),
                      ),
                    )
                    .then((_) {
                      // Cuando el diálogo se cierra, recargar toda la página de noticias
                      if (context.mounted) {
                        // Recargamos todas las noticias
                        context.read<NoticiasBloc>().add(const FetchNoticias());

                        // También actualizamos el contador específico de comentarios
                        context.read<ComentarioBloc>().add(
                          GetNumeroComentarios(noticiaId: noticia.id!),
                        );
                      }
                    });
              },
            );
          },
          separatorBuilder:
              (context, index) =>
                  const Divider(color: Colors.grey, thickness: 0.5, height: 1),
        );
      }
    }
    // Estado predeterminado o error
    return const Center(child: Text('Algo salió mal al cargar las noticias.'));  }  
  
  Future<void> _editarNoticia(BuildContext context, Noticia noticia) async {
    await NoticiaModal.mostrarModal(
      context: context,
      noticia: noticia.toMap(),
      onSave: (oldNoticia, noticiaActualizada) {
        // Crear una nueva instancia de Noticia con los datos actualizados
        final noticiaModel = Noticia(
          id: noticia.id,
          titulo: noticiaActualizada['titulo'],
          descripcion: noticiaActualizada['descripcion'],
          fuente: noticiaActualizada['fuente'],
          publicadaEl: DateTime.parse(noticiaActualizada['publicadaEl']),
          urlImagen: noticiaActualizada['urlImagen'],
          categoriaId: noticiaActualizada['categoriaId'],
        );

        // Llamar al evento UpdateNoticia del bloc
        context.read<NoticiasBloc>().add(UpdateNoticia(noticia.id!, noticiaModel));
        
        // Mostrar mensaje de éxito
        SnackBarHelper.showSnackBar(
          context,
          ApiConstantes.newssuccessUpdated,
          statusCode: 200,
        );

        // También recargamos las noticias para asegurar que se muestren actualizadas
        Future.delayed(const Duration(milliseconds: 300), () {
          if (context.mounted) {
            context.read<NoticiasBloc>().add(const FetchNoticias());
          }
        });
      },
    );
  }

  void _mostrarError(BuildContext context, int? statusCode) {
    final errorData = ErrorHelper.getErrorMessageAndColor(statusCode);
    final message = errorData['message'];

    SnackBarHelper.showSnackBar(
      context,
      message,
      statusCode:
          statusCode, // Pasar el código de estado para el color adecuado
    );
  }

  /// Muestra un diálogo para reportar una noticia
  Future<void> _mostrarDialogoReporte(
    BuildContext context,
    String noticiaId,
  ) async {
    MotivoReporte motivoSeleccionado = MotivoReporte.otro;

    // Obtener una instancia fresca del ReporteBloc
    final reporteBloc = di<ReporteBloc>();

    await showDialog(
      context: context,
      barrierDismissible: false, // Evitar cierre al tocar fuera del diálogo
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: reporteBloc,
          child: BlocConsumer<ReporteBloc, ReporteState>(
            listener: (context, state) {
              if (state is ReporteCreated) {
                SnackBarHelper.showSuccess(
                  context,
                  'Reporte enviado correctamente',
                );
                Navigator.of(context).pop(); // Cerrar el diálogo cuando el reporte se ha creado
              } else if (state is ReporteError) {
                SnackBarHelper.showClientError(
                  context,
                  'Error al enviar el reporte: ${state.message}',
                );
              }
            },
            builder: (context, state) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reportar Noticia',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Selecciona el motivo del reporte:',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      
                      // Opciones con iconos
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                // Opción: Inapropiada
                          _buildOpcionReporte(
                            context: context,
                            icono: Icons.block,
                            color: Colors.redAccent.withOpacity(0.2),
                            iconColor: Colors.redAccent,
                            texto: 'Inapropiada',
                            onTap: () {
                              motivoSeleccionado = MotivoReporte.noticiaInapropiada;
                              _enviarReporte(context, reporteBloc, noticiaId, motivoSeleccionado);
                            },
                          ),
                          
                          // Opción: Falsa
                          _buildOpcionReporte(
                            context: context,
                            icono: Icons.warning_amber_rounded,
                            color: Colors.orangeAccent.withOpacity(0.2),
                            iconColor: Colors.orangeAccent,
                            texto: 'Falsa',
                            onTap: () {
                              motivoSeleccionado = MotivoReporte.informacionFalsa;
                              _enviarReporte(context, reporteBloc, noticiaId, motivoSeleccionado);
                            },
                          ),
                          
                          // Opción: Otro
                          _buildOpcionReporte(
                            context: context,
                            icono: Icons.flag_rounded,
                            color: Colors.blue.withOpacity(0.2),
                            iconColor: Colors.blue,
                            texto: 'Otro',
                            onTap: () {
                              motivoSeleccionado = MotivoReporte.otro;
                              _enviarReporte(context, reporteBloc, noticiaId, motivoSeleccionado);
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Indicador de cargando
                      if (state is ReporteLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      
                      // Botón Cerrar
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Cerrar',
                            style: TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
    /// Construye una opción de reporte con icono
  Widget _buildOpcionReporte({
    required BuildContext context,
    required IconData icono,
    required Color color,
    required Color iconColor,
    required String texto,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icono,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              texto,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Método auxiliar para enviar el reporte
  void _enviarReporte(BuildContext context, ReporteBloc bloc, String noticiaId, MotivoReporte motivo) {
    // Reiniciar el estado del bloc si hubo un error previo
    if (bloc.state is ReporteError) {
      bloc.add(ReporteInitEvent());
    }

    // Enviar el reporte utilizando el bloc
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (!context.mounted) return;
        bloc.add(
          ReporteCreateEvent(
            noticiaId: noticiaId,
            motivo: motivo,
          ),
        );
      },
    );
  }
}
