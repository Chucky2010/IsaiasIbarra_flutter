import 'package:equatable/equatable.dart';
import 'package:mi_proyecto/domain/tarea.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

abstract class TareaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TareaInitial extends TareaState {}

class TareaLoading extends TareaState {}

enum TipoOperacionTarea { cargar, crear, editar, eliminar }

class TareaError extends TareaState {
  final ApiException error;

  TareaError(this.error);

  @override
  List<Object?> get props => [error];
}

class TareaLoaded extends TareaState {
  final List<Tarea> tareas;
  final DateTime lastUpdated;
  final bool hayMasTareas;
  final int paginaActual;
  
  TareaLoaded({
    required this.tareas,
    required this.lastUpdated,
    this.hayMasTareas = true,
    this.paginaActual = 0,
  });

  @override
  List<Object?> get props => [tareas, lastUpdated, hayMasTareas, paginaActual];
}

class TareaOperationSuccess extends TareaState {
  final List<Tarea> tareas;
  final TipoOperacionTarea tipoOperacion;
  final String mensaje;

  TareaOperationSuccess(this.tareas, this.tipoOperacion, this.mensaje);

  @override
  List<Object?> get props => [tareas, tipoOperacion, mensaje];
}

class TareaCreated extends TareaOperationSuccess {
  TareaCreated(super.tareas, super.tipoOperacion, super.mensaje);
}

class TareaUpdated extends TareaOperationSuccess {
  TareaUpdated(super.tareas, super.tipoOperacion, super.mensaje);
}

class TareaDeleted extends TareaOperationSuccess {
  TareaDeleted(super.tareas, super.tipoOperacion, super.mensaje);
}



class TareaCompletada extends TareaOperationSuccess {
  final String id;
  final bool isCompleted;

  TareaCompletada(
    super.tareas, 
    super.tipoOperacion, 
    super.mensaje, 
    this.id, 
    this.isCompleted,
  );
  
  @override
  List<Object?> get props => [...super.props, id, isCompleted];
}