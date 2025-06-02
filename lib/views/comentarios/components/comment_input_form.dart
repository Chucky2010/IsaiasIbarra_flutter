import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/comentario/comentario_bloc.dart';
import 'package:mi_proyecto/bloc/comentario/comentario_event.dart';
import 'package:mi_proyecto/bloc/comentario/comentario_state.dart';
import 'package:mi_proyecto/domain/comentario.dart';
import 'package:mi_proyecto/helpers/snackbar_helper.dart';

class CommentInputForm extends StatelessWidget {
  final String noticiaId;
  final TextEditingController comentarioController;
  final String? respondingToId;
  final String? respondingToAutor;
  final VoidCallback onCancelarRespuesta;

  const CommentInputForm({
    super.key,
    required this.noticiaId,
    required this.comentarioController,
    required this.respondingToId,
    required this.respondingToAutor,
    required this.onCancelarRespuesta,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        if (respondingToId != null) _buildRespondingTo(),
        const SizedBox(height: 8),
        TextField(
          controller: comentarioController,
          decoration: InputDecoration(
            hintText:
                respondingToId == null
                    ? 'Escribe tu comentario'
                    : 'Escribe tu respuesta...',
            border: const OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => _handleSubmit(context),
          icon: const Icon(Icons.send),
          label: Text(
            respondingToId == null ? 'Publicar comentario' : 'Enviar respuesta',
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 10,
              bottom: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRespondingTo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Respondiendo a $respondingToAutor',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: onCancelarRespuesta,
            tooltip: 'Cancelar respuesta',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    if (comentarioController.text.trim().isEmpty) {
      SnackBarHelper.mostrarInfo(
        context,
        mensaje: 'El comentario no puede estar vacío',
      );
      return;
    }
    final fecha = DateTime.now().toIso8601String();
    final bloc = context.read<ComentarioBloc>();

    if (respondingToId == null) {
      // Crear un comentario principal
      final nuevoComentario = Comentario(
        id: '',
        noticiaId: noticiaId,
        texto: comentarioController.text,
        fecha: fecha,
        autor: 'Usuario anónimo',
        likes: 0,
        dislikes: 0,
        subcomentarios: [],
        isSubComentario: false,
      );

      bloc.add(AddComentario(noticiaId, nuevoComentario));
    } else {
      // Crear un subcomentario
      final nuevoSubComentario = Comentario(
        id: '', // El ID real se generará en el backend
        noticiaId: noticiaId,
        texto: comentarioController.text,
        fecha: fecha,
        autor: 'Usuario anónimo',
        likes: 0,
        dislikes: 0,
        subcomentarios:
            [], // Un subcomentario no puede tener sus propios subcomentarios
        isSubComentario: true,
        idSubComentario:
            respondingToId, // Este es el ID del comentario padre al que estamos respondiendo
      );

      bloc.add(AddSubcomentario(nuevoSubComentario));
    }

    // Actualizar el contador de comentarios
    int totalComentariosActuales = 0;
    if (bloc.state is ComentarioLoaded) {
      final comentariosActuales = (bloc.state as ComentarioLoaded).comentarios;
      
      // Contar comentarios principales
      totalComentariosActuales = comentariosActuales.length;
      
      // Contar subcomentarios
      for (var comentario in comentariosActuales) {
        if (comentario.subcomentarios != null) {
          totalComentariosActuales += comentario.subcomentarios!.length;
        }
      }
    }
    
    // Sumamos 1 por el nuevo comentario
    final nuevoTotal = totalComentariosActuales + 1;
    bloc.add(ActualizarContadorComentarios(noticiaId, nuevoTotal));
    
    comentarioController.clear();
    onCancelarRespuesta();

    SnackBarHelper.mostrarExito(
      context,
      mensaje: 'Comentario agregado con éxito',
    );
  }
}
