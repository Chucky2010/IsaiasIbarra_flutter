import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/contador/contador_event.dart';
import 'package:mi_proyecto/bloc/contador/contador_state.dart';


class ContadorBloc extends Bloc<ContadorEvent, ContadorState> {
  ContadorBloc() : super(const ContadorState()) {
    on<ContadorIncrementEvent>(_onIncrement);
    on<ContadorDecrementEvent>(_onDecrement);
    on<ContadorResetEvent>(_onReset);
  }

  void _onIncrement(
    ContadorIncrementEvent event,
    Emitter<ContadorState> emit,
  ) {
    emit(state.copyWith(
      valor: state.valor + 1,
      status: ContadorStatus.loaded,
    ));
  }

  void _onDecrement(
    ContadorDecrementEvent event,
    Emitter<ContadorState> emit,
  ) {
    emit(state.copyWith(
      valor: state.valor - 1,
      status: ContadorStatus.loaded,
    ));
  }

  void _onReset(
    ContadorResetEvent event,
    Emitter<ContadorState> emit,
  ) {
    emit(state.copyWith(
      valor: 0,
      status: ContadorStatus.loaded,
    ));
  }
}