import 'package:equatable/equatable.dart';

abstract class TareaContadorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TareaContadorIncrementEvent extends TareaContadorEvent {}

class TareaContadorDecrementEvent extends TareaContadorEvent {}

class TareaContadorResetEvent extends TareaContadorEvent {
  final int total;
  final int completadas;

  TareaContadorResetEvent({required this.total, required this.completadas});

  @override
  List<Object?> get props => [total, completadas];
}