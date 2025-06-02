import 'package:dart_mappable/dart_mappable.dart';
import 'package:mi_proyecto/domain/comentario.dart';

@MappableClass()
class ComentarioPrincipal extends Comentario {
  @MappableField()
  final List<Comentario>? subComentarios;

  ComentarioPrincipal({
    this.subComentarios,
    required super.noticiaId,
    required super.texto,
    required super.fecha,
    required super.autor,
    required super.likes,
    required super.dislikes,
  });
}
