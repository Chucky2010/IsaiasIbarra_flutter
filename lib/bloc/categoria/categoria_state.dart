import 'package:equatable/equatable.dart';
import 'package:mi_proyecto/domain/categoria.dart';

abstract class CategoriaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoriaInitialState extends CategoriaState {}

class CategoriaLoadingState extends CategoriaState {}

class CategoriaLoadedState extends CategoriaState {
  final List<Categoria> categorias;
  final DateTime ultimaActualizacion;

  CategoriaLoadedState(this.categorias, {DateTime? ultimaActualizacion})
      : ultimaActualizacion = ultimaActualizacion ?? DateTime.now();

  @override
  List<Object?> get props => [categorias, ultimaActualizacion];
}

class CategoriaErrorState extends CategoriaState {
  final String message;

  CategoriaErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

// Nuevo estado para operaciones exitosas
class CategoriaActionSuccess extends CategoriaState {
  final String message;
  
  CategoriaActionSuccess(this.message);
  
  @override
  List<Object?> get props => [message];
}