import 'package:equatable/equatable.dart';
import 'package:mi_proyecto/domain/categoria.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

abstract class CategoriaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoriaInitial extends CategoriaState {}

enum TipoOperacion { cargar, crear, actualizar, eliminar }

class CategoriaError extends CategoriaState {
  final ApiException error;
  final TipoOperacion tipoOperacion;

  CategoriaError(this.error, this.tipoOperacion);

  @override
  List<Object?> get props => [error, tipoOperacion];
}

class CategoriaLoading extends CategoriaState {}

class CategoriaLoaded extends CategoriaState {
  final List<Categoria> categorias;
  final DateTime lastUpdated;

  CategoriaLoaded(this.categorias, this.lastUpdated);

  @override
  List<Object?> get props => [categorias, lastUpdated];
}

class CategoriaCreated extends CategoriaLoaded {
  CategoriaCreated(super.categorias, super.lastUpdated);
}

class CategoriaUpdated extends CategoriaLoaded {
  CategoriaUpdated(super.categorias, super.lastUpdated);
}

class CategoriaDeleted extends CategoriaLoaded {
  CategoriaDeleted(super.categorias, super.lastUpdated);
}

/// Estado especial para cuando se recarga la caché forzadamente
class CategoriaReloaded extends CategoriaLoaded {
  CategoriaReloaded(super.categorias, super.lastUpdated);
}
