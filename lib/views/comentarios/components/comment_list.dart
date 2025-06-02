import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/comentario/comentario_bloc.dart';
import 'package:mi_proyecto/bloc/comentario/comentario_event.dart';
import 'package:mi_proyecto/bloc/comentario/comentario_state.dart';
import 'package:mi_proyecto/domain/comentario.dart';
import 'package:mi_proyecto/helpers/snackbar_helper.dart';
import 'package:mi_proyecto/views/comentarios/components/comment_card.dart';

class CommentList extends StatefulWidget{
  final String noticiaId;
  final Function(String, String) onResponderComentario;

  const CommentList({
    super.key,
    required this.noticiaId,
    required this.onResponderComentario,
  });
   @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  // Track which comments have their subcomments expanded
  final Map<String, bool> _expandedComments = {};


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComentarioBloc, ComentarioState>(      
      listener: (context, state) {
        if (state is ComentarioError) {
          SnackBarHelper.manejarError(
            context,
            state.error,
          );
        }
      },
      builder: (context, state) {
        if (state is ComentarioLoading) {
          return const Center(child: CircularProgressIndicator());  
        } else if (state is ReaccionLoading) {
          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: const Color(0x0D000000), // Negro con 20% opacidad
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          );      
        } else if (state is ComentarioLoaded) {
          return _buildList(context, state.comentarios);
        } else if (state is ComentarioError) {
          return _buildErrorState(context);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildList(BuildContext context, List<Comentario> comentarios) { // Recibir context
    if (comentarios.isEmpty) {
      return const Center(
        child: Text(
          'No hay comentarios que coincidan con tu búsqueda',
          textAlign: TextAlign.center,
        ),
      );
    }

       // Separate top-level comments and subcomments
    final topLevelComments = comentarios.where((c) => c.idSubComentario == null).toList();
    final subComments = <String, List<Comentario>>{};
    for (var comment in comentarios.where((c) => c.idSubComentario != null)) {
      subComments.putIfAbsent(comment.idSubComentario!, () => []).add(comment);
    }
    return ListView.separated(
      itemCount: topLevelComments.length,
      itemBuilder: (context, index) {
        final comentario = topLevelComments[index];
        final commentSubComments = subComments[comentario.id] ?? [];

        // Toggle state for this comment's subcomments
        final isExpanded = _expandedComments[comentario.id] ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Render the parent comment
            CommentCard(
              comentario: comentario,
              noticiaId: widget.noticiaId,
              onResponder: widget.onResponderComentario,
            ),
            if (commentSubComments.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _expandedComments[comentario.id!] = !isExpanded;
                      });
                    },
                    child: Text(
                      isExpanded ? 'Show Less' : 'Show More (${commentSubComments.length})',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: commentSubComments.map((subComment) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: CommentCard(
                          comentario: subComment,
                          noticiaId: widget.noticiaId,
                          onResponder: widget.onResponderComentario,
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ],
        );
      },
      separatorBuilder: (_, __) => const Divider(),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            'Error al cargar comentarios',
            style: TextStyle(color: Colors.red[700]),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => context.read<ComentarioBloc>().add(LoadComentarios(widget.noticiaId)),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}