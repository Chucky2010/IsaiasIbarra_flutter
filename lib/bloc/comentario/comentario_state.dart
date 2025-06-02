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

  ComentarioLoaded({required this.comentarios, required this.noticiaId});

  @override
  List<Object?> get props => [comentarios, noticiaId];
}

class ReaccionLoading extends ComentarioState {}

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
  final ApiException error;

  ComentarioError(this.error);

  @override
  List<Object> get props => [error];
}

class ComentariosFiltrados extends ComentarioLoaded {
  final String terminoBusqueda;

  ComentariosFiltrados({
    required super.comentarios,
    required super.noticiaId,
    required this.terminoBusqueda,
  });

  @override
  List<Object?> get props => [...super.props, terminoBusqueda];
}

class ComentariosOrdenados extends ComentarioLoaded {
  final String criterioOrden;

  ComentariosOrdenados({
    required super.comentarios,
    required super.noticiaId,
    required this.criterioOrden,
  });

  @override
  List<Object?> get props => [...super.props, criterioOrden];
}

class ContadorComentariosActualizado extends ComentarioState {
  final String noticiaId;
  final int contadorComentarios;

  ContadorComentariosActualizado({
    required this.noticiaId,
    required this.contadorComentarios,
  });

  @override
  List<Object?> get props => [noticiaId, contadorComentarios];
}
