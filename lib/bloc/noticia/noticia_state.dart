import 'package:equatable/equatable.dart';
import 'package:mi_proyecto/domain/noticia.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

abstract class NoticiaState extends Equatable {
  @override
  List<Object> get props => [];
}

class NoticiaInitial extends NoticiaState {}

class NoticiaLoading extends NoticiaState {}

class NoticiaLoaded extends NoticiaState {
  final List<Noticia> noticias;
  final DateTime lastUpdated;

  NoticiaLoaded(this.noticias, this.lastUpdated);

  @override
  List<Object> get props => [noticias, lastUpdated];
}

enum TipoOperacionNoticia { cargar, crear, actualizar, eliminar, filtrar }

class NoticiaError extends NoticiaState {
  final ApiException error;
  final TipoOperacionNoticia tipoOperacion;

  NoticiaError(this.error, this.tipoOperacion);

  @override
  List<Object> get props => [error, tipoOperacion];
}

class NoticiaCreated extends NoticiaLoaded {
  NoticiaCreated(super.noticias, super.lastUpdated);
}

class NoticiaUpdated extends NoticiaLoaded {
  NoticiaUpdated(super.noticias, super.lastUpdated);
}

class NoticiaDeleted extends NoticiaLoaded {
  NoticiaDeleted(super.noticias, super.lastUpdated);
}

class NoticiaFiltered extends NoticiaLoaded {
  final List<String> appliedFilters;

  NoticiaFiltered(super.noticias, super.lastUpdated, this.appliedFilters);

  @override
  List<Object> get props => [...super.props, appliedFilters];
}
