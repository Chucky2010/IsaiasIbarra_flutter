import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_bloc.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_event.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/domain/noticia.dart';
import 'package:intl/intl.dart';
import 'package:mi_proyecto/views/comentarios/comentarios_screen.dart';
import 'package:mi_proyecto/components/reporte_dialog.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final VoidCallback onEdit;
  final String categoriaNombre;
  final VoidCallback? onReport;

  const NoticiaCard({
    super.key,
    required this.noticia,
    required this.onEdit,
    required this.categoriaNombre,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    // Usar el tema actual para obtener colores apropiados
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.only(
            top: 16.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
          ),
          // Usar el color de la tarjeta del tema en lugar de hardcodear Colors.white
          color: theme.cardColor,
          shape: null,
          elevation: 0.0,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.category, 
                      size: 14, 
                      // Usar el color de ícono apropiado del tema
                      color: theme.colorScheme.onSurface,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      categoriaNombre,
                      style: TextStyle(
                        // Usar el color de texto apropiado del tema
                        color: theme.colorScheme.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Primera fila: Texto y la imagen
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Columna para el texto (2/3 del ancho)
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            noticia.titulo,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            // Usar estilo de texto del tema
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            noticia.descripcion,
                            // Usar estilo de texto del tema con opacidad
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            noticia.fuente,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            _formatDate(noticia.publicadaEl),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        noticia.urlImagen.isNotEmpty
                            ? noticia.urlImagen
                            : 'https://via.placeholder.com/100',
                        height: 80,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Adaptar el contenedor al tema
                          return Container(
                            height: 80,
                            width: 100,
                            // Color apropiado según el tema
                            color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                            child: Icon(
                              Icons.broken_image,
                              // Color apropiado según el tema
                              color: isDarkMode ? Colors.grey[600] : Colors.grey[500],
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.star_border, 
                      // Color del ícono según el tema
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: () {
                      // Acción para marcar como favorito
                    },
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.comment,
                          // Color del ícono según el tema
                          color: theme.colorScheme.onSurface,
                        ),
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ComentariosScreen(
                                noticiaId: noticia.id!,
                                noticiaTitulo: noticia.titulo,
                              ),
                            ),
                          );
                          if (context.mounted) {
                            context.read<NoticiaBloc>().add(FetchNoticiasEvent());
                          }
                        },
                        tooltip: 'Ver comentarios',
                      ),
                      if ((noticia.contadorComentarios ?? 0) > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              // Usar color primario del tema
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              (noticia.contadorComentarios ?? 0) > 99
                                  ? '99+'
                                  : (noticia.contadorComentarios ?? 0).toString(),
                              style: TextStyle(
                                // Usar color apropiado para texto sobre color primario
                                color: theme.colorScheme.onPrimary,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.flag,
                          // Color del ícono según el tema
                          color: theme.colorScheme.onSurface,
                        ),
                        onPressed: () {
                          if (onReport != null) {
                            onReport!();
                          } else {
                            ReporteDialog.mostrarDialogoReporte(
                              context: context,
                              noticia: noticia,
                            );
                          }
                        },
                        tooltip: 'Reportar noticia',
                      ),
                      if (noticia.contadorReportes != null && noticia.contadorReportes! > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              // Usar color de error del tema
                              color: theme.colorScheme.error,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              noticia.contadorReportes! > 99
                                  ? '99+'
                                  : noticia.contadorReportes.toString(),
                              style: TextStyle(
                                // Usar color apropiado para texto sobre color de error
                                color: theme.colorScheme.onError,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.edit,
                      // Color del ícono según el tema
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: onEdit,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 17.0,
            vertical: 0.0,
          ),
          // Usar el color del divisor del tema
          child: Divider(color: theme.dividerColor),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat(AppConstantes.formatoFecha).format(date);
  }
}
