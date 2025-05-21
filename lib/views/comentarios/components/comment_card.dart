import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/comentario/comentario_bloc.dart';
import 'package:kgaona/bloc/comentario/comentario_event.dart';
import 'package:kgaona/domain/comentario.dart';
import 'package:kgaona/views/comentarios/components/subcomment_card.dart';

class CommentCard extends StatelessWidget {
  final Comentario comentario;
  final String noticiaId;
  final Function(String, String) onResponder;

  const CommentCard({
    super.key,
    required this.comentario,
    required this.noticiaId,
    required this.onResponder,
  });

  @override
  Widget build(BuildContext context) {    // La fecha ya viene formateada del backend, la usamos directamente
    final fecha = comentario.fecha;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comentario.autor,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(comentario.texto),
                const SizedBox(height: 8),
                Text(
                  fecha,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
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
                      comentario.likes.toString(),
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
                      comentario.dislikes.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      icon: const Icon(Icons.reply, size: 24),
                      label: const Text('Responder'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => onResponder(comentario.id ?? '', comentario.autor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (comentario.subcomentarios != null &&
              comentario.subcomentarios!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.grey.shade300, width: 2),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comentario.subcomentarios!.length,                itemBuilder: (context, index) => SubcommentCard(
                  subcomentario: comentario.subcomentarios![index],
                  noticiaId: noticiaId,
                ),
              ),
            ),
        ],
      ),
    );
  }  void _handleReaction(BuildContext context, String tipoReaccion) {
    // Capturamos una referencia al bloc fuera del Future.delayed
    final comentarioBloc = context.read<ComentarioBloc>();
    final String currentNoticiaId = noticiaId;
    
    // Primero enviamos el evento de reacción
    comentarioBloc.add(
      AddReaccion(
        comentario.id ?? '', 
        tipoReaccion, 
        true, // incrementar = true
        null // comentarioPadreId null para comentarios principales
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