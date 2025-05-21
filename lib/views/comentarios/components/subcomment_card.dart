import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/comentario/comentario_bloc.dart';
import 'package:kgaona/bloc/comentario/comentario_event.dart';
import 'package:kgaona/domain/comentario.dart';

class SubcommentCard extends StatelessWidget {
  final Comentario subcomentario;
  final String noticiaId;

  const SubcommentCard({
    super.key,
    required this.subcomentario,
    required this.noticiaId,
  });
  @override
  Widget build(BuildContext context) {
    // La fecha ya viene formateada desde el backend
    final fecha = subcomentario.fecha;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                subcomentario.autor,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subcomentario.texto, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            fecha,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          // Botones de reacción (like/dislike)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.thumb_up_sharp,
                  size: 16,
                  color: Colors.green,
                ),
                onPressed: () => _handleReaction(context, 'like'),
              ),
              Text(
                subcomentario.likes.toString(),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.thumb_down_sharp,
                  size: 16,
                  color: Colors.red,
                ),
                onPressed: () => _handleReaction(context, 'dislike'),
              ),
              Text(
                subcomentario.dislikes.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }  void _handleReaction(BuildContext context, String tipoReaccion) {
    // Capturamos una referencia al bloc fuera del Future.delayed
    final comentarioBloc = context.read<ComentarioBloc>();
    final String currentNoticiaId = noticiaId;
    
    // Determinamos correctamente los IDs para la reacción
    String comentarioId = '';
    String? padreId;
    
    // Si tiene ID propio, lo usamos directamente
    if (subcomentario.id != null && subcomentario.id!.isNotEmpty) {
      comentarioId = subcomentario.id!;
      
      // Si además tiene idSubComentario, ese es el padre
      if (subcomentario.idSubComentario != null && subcomentario.idSubComentario!.isNotEmpty) {
        padreId = subcomentario.idSubComentario;
      }
    } 
    // Si no tiene ID propio pero tiene idSubComentario, usamos ese como su ID
    else if (subcomentario.idSubComentario != null && subcomentario.idSubComentario!.isNotEmpty) {
      comentarioId = subcomentario.idSubComentario!;
    }
    
    // Agregamos la reacción con los IDs correctos
    comentarioBloc.add(
      AddReaccion(
        comentarioId,
        tipoReaccion,
        true,
        padreId,
      ),
    );
    
    // Luego forzamos la recarga de comentarios para actualizar la UI
    // No usamos context dentro del Future.delayed
    Future.delayed(const Duration(milliseconds: 500), () {
      comentarioBloc.add(
        LoadComentarios(currentNoticiaId),
      );
    });
  }
}
