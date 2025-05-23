import 'package:equatable/equatable.dart';
import 'package:mi_proyecto/domain/comentario.dart';

abstract class ComentarioEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadComentarios extends ComentarioEvent {
  final String noticiaId;

  LoadComentarios(this.noticiaId);

  @override
  List<Object> get props => [noticiaId];
}

class AddComentario extends ComentarioEvent {
  final String noticiaId;
  final Comentario comentario;

  AddComentario(this.noticiaId, this.comentario);

  @override
  List<Object> get props => [comentario];
}

class GetNumeroComentarios extends ComentarioEvent {
  final String noticiaId;

  GetNumeroComentarios(this.noticiaId);

  @override
  List<Object> get props => [noticiaId];
}

class AddReaccion extends ComentarioEvent {
  final String comentarioId;
  final String tipoReaccion;
  final bool incrementar;
  final String? comentarioPadreId;

  AddReaccion(
    this.comentarioId, 
    this.tipoReaccion, 
    this.incrementar,
    [this.comentarioPadreId]
  );

  @override
  List<Object?> get props => [comentarioId, tipoReaccion, incrementar, comentarioPadreId];
}

class BuscarComentarios extends ComentarioEvent {
  final String terminoBusqueda;
  final String noticiaId;

  BuscarComentarios(this.terminoBusqueda, this.noticiaId);

  @override
  List<Object> get props => [terminoBusqueda, noticiaId];
}

class OrdenarComentarios extends ComentarioEvent {
  final bool ascendente;

  OrdenarComentarios(this.ascendente);

  @override
  List<Object> get props => [ascendente];
}

class AddSubcomentario extends ComentarioEvent {
  final Comentario subcomentario;

  AddSubcomentario(this.subcomentario);

  @override
  List<Object> get props => [subcomentario];
}
