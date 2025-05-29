import 'package:equatable/equatable.dart';
import 'package:mi_proyecto/domain/tarea.dart';

abstract class TareaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTareasEvent extends TareaEvent {
  final bool forzarRecarga;
  
  LoadTareasEvent({this.forzarRecarga = false});
  
  @override
  List<Object?> get props => [forzarRecarga];
}

// Events para paginación y scroll infinito
class LoadMoreTareasEvent extends TareaEvent {
  final int pagina;
  final int limite;
  
  LoadMoreTareasEvent({
    required this.pagina,
    required this.limite,
  });
}

class CreateTareaEvent extends TareaEvent {
  final Tarea tarea;
  
  CreateTareaEvent(this.tarea);
  
  @override
  List<Object?> get props => [tarea];
}

class UpdateTareaEvent extends TareaEvent {
  final Tarea tarea;
  
  UpdateTareaEvent(this.tarea);
  
  @override
  List<Object?> get props => [tarea];
}

class DeleteTareaEvent extends TareaEvent {
  final String id;
  
  DeleteTareaEvent(this.id);
  
  @override
  List<Object?> get props => [id];
}

// Añadir este evento a los existentes
class ToggleCompletadoTareaEvent extends TareaEvent {
  final String id;
  final bool isCompleted;
  
  ToggleCompletadoTareaEvent({
    required this.id, 
    required this.isCompleted,
  });
  
  @override
  List<Object?> get props => [id, isCompleted];
}