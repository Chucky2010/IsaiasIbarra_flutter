import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/tarea_contador/tarea_contador_event.dart';
import 'package:mi_proyecto/bloc/tarea_contador/tarea_contador_state.dart';

class TareaContadorBloc extends Bloc<TareaContadorEvent, TareaContadorState> {
  TareaContadorBloc() : super(const TareaContadorState()) {
    on<TareaContadorIncrementEvent>(_onIncrement);
    on<TareaContadorDecrementEvent>(_onDecrement);
    on<TareaContadorResetEvent>(_onReset);
  }

  void _onIncrement(
    TareaContadorIncrementEvent event,
    Emitter<TareaContadorState> emit,
  ) {
    emit(state.copyWith(
      completadas: state.completadas + 1,
    ));
  }

  void _onDecrement(
    TareaContadorDecrementEvent event,
    Emitter<TareaContadorState> emit,
  ) {
    emit(state.copyWith(
      completadas: state.completadas > 0 ? state.completadas - 1 : 0,
    ));
  }

  void _onReset(
    TareaContadorResetEvent event,
    Emitter<TareaContadorState> emit,
  ) {
    emit(TareaContadorState(
      completadas: event.completadas,
      total: event.total,
    ));
  }
}