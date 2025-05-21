import 'package:flutter/material.dart';
import 'package:mi_proyecto/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/comentarios/comentario_bloc.dart';
import 'package:mi_proyecto/bloc/comentarios/comentario_event.dart';
import 'package:mi_proyecto/bloc/comentarios/comentario_state.dart';
import 'package:mi_proyecto/bloc/reportes/reportes_bloc.dart';
import 'package:mi_proyecto/bloc/reportes/reportes_event.dart';
import 'package:mi_proyecto/bloc/reportes/reportes_state.dart';
import 'package:mi_proyecto/helpers/category_helper.dart';

class NoticiaCard extends StatefulWidget {
  final String? id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final String publicadaEl;
  final String imageUrl;
  final String categoriaId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onComment;
  final VoidCallback onReport;
  final String categoriaNombre;
  const NoticiaCard({
    super.key,
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.imageUrl,
    required this.categoriaId,
    required this.onEdit,
    required this.onDelete,
    required this.categoriaNombre,
    required this.onComment,
    required this.onReport,
  });

  @override
  State<NoticiaCard> createState() => _NoticiaCardState();
}

class _NoticiaCardState extends State<NoticiaCard> {
  int _numeroComentarios = 0;
  int _numeroReportes = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      if (_isLoading) {
        if (widget.id != null) {
          // Cargar número de comentarios
          context.read<ComentarioBloc>().add(
            GetNumeroComentarios(noticiaId: widget.id!),
          );
          
          // Cargar número de reportes
          context.read<ReporteBloc>().add(
            GetNumeroReportesEvent(noticiaId: widget.id!),
          );
        }
        _isLoading = false;
      }

      // Manejar estado de comentarios
      final commentState = context.watch<ComentarioBloc>().state;
      if (commentState is NumeroComentariosLoaded && commentState.noticiaId == widget.id) {
        if (_numeroComentarios != commentState.numeroComentarios) {
          setState(() {
            _numeroComentarios = commentState.numeroComentarios;
          });
        }
      }      // Manejar estado de reportes
      final reporteState = context.watch<ReporteBloc>().state;
      // Verificar tanto NumeroReportesLoaded como ReporteCreated ya que ambos pueden indicar cambios
      if (reporteState is NumeroReportesLoaded && reporteState.noticiaId == widget.id) {
        if (_numeroReportes != reporteState.numeroReportes) {
          setState(() {
            _numeroReportes = reporteState.numeroReportes;
            debugPrint('NoticiaCard: Actualizando número de reportes a $_numeroReportes para noticia ${widget.id}');
          });
        }
      } else if (reporteState is ReporteCreated) {
        // Cuando se crea un nuevo reporte, solicitar actualización del contador
        debugPrint('NoticiaCard: Detectado ReporteCreated, solicitando actualización del contador');
        context.read<ReporteBloc>().add(GetNumeroReportesEvent(noticiaId: widget.id!));
      }
    } catch (e) {
      debugPrint('Error al cargar datos de la noticia: $e');
    }
  }

  Future<String> _obtenerNombreCategoria(String categoriaId) async {
    // Usar el nuevo helper que implementa la caché de categorías
    return await CategoryHelper.getCategoryName(categoriaId);
  }

  @override
  Widget build(BuildContext context) {
    // Añadir un BlocListener para detectar cambios en ReporteBloc
    return BlocListener<ReporteBloc, ReporteState>(      listenWhen: (previous, current) {
        // Solo escuchar cuando el estado es relevante para esta noticia y tenemos un ID válido
        if (widget.id == null) return false;
        
        return (current is NumeroReportesLoaded && current.noticiaId == widget.id) || 
               (current is ReporteCreated && current.reporte.noticiaId == widget.id);
      },
      listener: (context, state) {
        if (state is NumeroReportesLoaded && state.noticiaId == widget.id) {
          if (_numeroReportes != state.numeroReportes) {
            setState(() {
              _numeroReportes = state.numeroReportes;
              debugPrint('BlocListener: Actualizando número de reportes a $_numeroReportes para noticia ${widget.id}');
            });
          }
        } else if (state is ReporteCreated && state.reporte.noticiaId == widget.id) {
          // Cuando se crea un nuevo reporte, solicitar actualización del contador
          debugPrint('BlocListener: Detectado ReporteCreated, solicitando actualización del contador');
          context.read<ReporteBloc>().add(GetNumeroReportesEvent(noticiaId: widget.id!));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.espaciadoAlto,
          horizontal: 16,
        ),
        child: Card(
          color: Colors.white,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primera columna: Información de la noticia
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.titulo,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.fuente,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.descripcion,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${AppConstants.publicadaEl} ${widget.publicadaEl}',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      const SizedBox(height: 1),
                      FutureBuilder<String>(
                        future: _obtenerNombreCategoria(widget.categoriaId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text(
                              'Cargando...',
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Error',
                              style: TextStyle(fontSize: 10, color: Colors.red),
                            );
                          }
                          final categoriaNombre = snapshot.data ?? 'Sin categoría';
                          return Text(
                            'Cat: $categoriaNombre',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 8), // Espacio entre columnas
                
                // Segunda columna: Imagen y acciones
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 24),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 8),
                    
                    // Botones de acción
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Fila 1: Comentarios
                        InkWell(
                          onTap: widget.onComment,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$_numeroComentarios',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.comment,
                                size: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Fila 2: Reportes
                        InkWell(
                          onTap: widget.onReport,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$_numeroReportes',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.report,
                                size: 16,
                                color: _numeroReportes > 0 ? Colors.red : Colors.amber,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Fila 3: Menú
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            size: 18,
                          ),
                          padding: EdgeInsets.zero,
                          iconSize: 18,
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Editar',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Eliminar',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (String value) {
                            if (value == 'edit') {
                              widget.onEdit();
                            } else if (value == 'delete') {
                              widget.onDelete();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
