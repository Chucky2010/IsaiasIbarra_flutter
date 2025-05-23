import 'package:equatable/equatable.dart';
import 'package:mi_proyecto/domain/comentario.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

abstract class ComentarioState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ComentarioInitial extends ComentarioState {}

class ComentarioLoading extends ComentarioState {}

class ComentarioLoaded extends ComentarioState {
  final List<Comentario> comentarios;
  final String noticiaId;

  ComentarioLoaded(this.comentarios, this.noticiaId);

  @override
  List<Object?> get props => [comentarios, noticiaId];
}

class NumeroComentariosLoaded extends ComentarioState {
  final int numeroComentarios;
  final String noticiaId;

  NumeroComentariosLoaded(this.numeroComentarios, this.noticiaId);

  @override
  List<Object> get props => [numeroComentarios, noticiaId];
}

enum TipoOperacionComentario {
  cargar,
  agregar,
  buscar,
  ordenar,
  reaccionar,
  agregarSubcomentario,
  obtenerNumero,
}

class ComentarioError extends ComentarioState {
  final String message;
  final ApiException error;
  final TipoOperacionComentario tipoOperacion;

  ComentarioError(this.message, this.error, this.tipoOperacion);

  @override
  List<Object> get props => [message, error, tipoOperacion];
}

class ComentariosFiltrados extends ComentarioLoaded {
  final String terminoBusqueda;

  ComentariosFiltrados(
    super.comentarios,
    super.noticiaId,
    this.terminoBusqueda,
  );

  @override
  List<Object?> get props => [...super.props, terminoBusqueda];
}

class ComentariosOrdenados extends ComentarioLoaded {
  final String criterioOrden;

  ComentariosOrdenados(
    super.comentarios,
    super.noticiaId,
    this.criterioOrden,
  );

  @override
  List<Object?> get props => [...super.props, criterioOrden];
}
