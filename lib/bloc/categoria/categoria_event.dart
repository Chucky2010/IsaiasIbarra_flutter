import 'package:equatable/equatable.dart';
import 'package:mi_proyecto/domain/categoria.dart';

abstract class CategoriaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoriaInitEvent extends CategoriaEvent {
  final bool forzarRecarga;
  
  CategoriaInitEvent({this.forzarRecarga = false});
  
  @override
  List<Object?> get props => [forzarRecarga];
}

class CategoriaCreateEvent extends CategoriaEvent {
  final Categoria categoria;

  CategoriaCreateEvent(this.categoria);

  @override
  List<Object?> get props => [categoria];
}

class CategoriaUpdateEvent extends CategoriaEvent {
  final Categoria categoria;

  CategoriaUpdateEvent(this.categoria);

  @override
  List<Object?> get props => [categoria];
}

class CategoriaDeleteEvent extends CategoriaEvent {
  final String id;

  CategoriaDeleteEvent(this.id);

  @override
  List<Object?> get props => [id];
}
