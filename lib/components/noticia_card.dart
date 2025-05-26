import 'package:flutter/material.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/domain/noticia.dart';
import 'package:intl/intl.dart';
import 'package:mi_proyecto/views/comentarios/comentarios_screen.dart';
import 'package:mi_proyecto/components/reporte_dialog.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final VoidCallback onEdit; // Callback para editar la noticia
  final String
  categoriaNombre; // Nuevo parámetro para mostrar el nombre de la categoría
  final VoidCallback? onReport; // Callback para reportar la noticia

  const NoticiaCard({
    super.key,
    required this.noticia,
    required this.onEdit,
    required this.categoriaNombre,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.only(
            top: 16.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
          ), // Margen de la tarjeta
          color: Colors.white,
          shape: null,
          elevation: 0.0,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.category, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    categoriaNombre,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            noticia.descripcion,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            noticia.fuente,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            _formatDate(noticia.publicadaEl),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
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
                            : 'https://via.placeholder.com/100', // Imagen por defecto si no hay URL
                        height: 80, // Altura de la imagen
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Widget alternativo cuando la imagen no carga
                          return Container(
                            height: 80,
                            width: 100,
                            color: Colors.grey[300], // Fondo gris claro
                            child: const Icon(
                              Icons.broken_image, // Ícono de imagen rota
                              color: Colors.grey,
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
                mainAxisAlignment:
                    MainAxisAlignment.end, // Alinea los botones al final
                children: [
                  IconButton(
                    icon: const Icon(Icons.star_border),
                    onPressed: () {
                      // Acción para marcar como favorito
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: () {
                      // Navegar a la vista de comentarios
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => ComentariosScreen(
                                noticiaId: noticia.id!,
                                noticiaTitulo: noticia.titulo,
                              ),
                        ),
                      );
                    },
                    tooltip: 'Ver comentarios',
                  ),                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      // Acción para compartir
                    },
                  ),                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.flag),
                        onPressed: () {
                          // Acción para reportar noticia
                          if (onReport != null) {
                            onReport!();
                          } else {
                            // Si no se proporcionó un callback, usar el diálogo de reportes directamente
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
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              noticia.contadorReportes! > 99 ? '99+' : noticia.contadorReportes.toString(),
                              style: const TextStyle(
                                color: Colors.white,
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
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Acción para mostrar más opciones
                      onEdit();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 17.0,
            vertical: 0.0,
          ), // Padding horizontal de 16
          child: Divider(color: Colors.grey),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat(AppConstantes.formatoFecha).format(date);
  }
}
