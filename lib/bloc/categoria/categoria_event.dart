import 'package:equatable/equatable.dart';
import 'package:mi_proyecto/domain/categoria.dart';

abstract class CategoriaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCategoriasEvent extends CategoriaEvent {}

class RefreshCategoriasEvent extends CategoriaEvent {}

class AddCategoriaEvent extends CategoriaEvent {
  final Categoria categoria;

  AddCategoriaEvent(this.categoria);

  @override
  List<Object?> get props => [categoria];
}

class UpdateCategoriaEvent extends CategoriaEvent {
  final String id;
  final Categoria categoria;

  UpdateCategoriaEvent(this.id, this.categoria);

  @override
  List<Object?> get props => [id, categoria];
}

class DeleteCategoriaEvent extends CategoriaEvent {
  final String categoriaId;

  DeleteCategoriaEvent(this.categoriaId);

  @override
  List<Object?> get props => [categoriaId];
}