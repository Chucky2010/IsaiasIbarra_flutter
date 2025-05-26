import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/connectivity/connectivity_event.dart';
import 'package:mi_proyecto/bloc/connectivity/connectivity_state.dart';
import 'package:mi_proyecto/helpers/connectivity_service.dart';
import 'package:watch_it/watch_it.dart';

/// BLoC para gestionar el estado de la conectividad a Internet en la aplicación
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _connectivityService = di<ConnectivityService>();
  late StreamSubscription _connectivitySubscription;

  ConnectivityBloc() : super(ConnectivityInitial()) {
    on<CheckConnectivity>(_onCheckConnectivity);
    on<ConnectivityStatusChanged>(_onConnectivityStatusChanged);

    // Suscripción a cambios de conectividad
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) {
      add(ConnectivityStatusChanged(result));
    });

    // Verificación inicial
    add(CheckConnectivity());
  }

  Future<void> _onCheckConnectivity(
    CheckConnectivity event,
    Emitter<ConnectivityState> emit,
  ) async {
    final isConnected = await _connectivityService.hasInternetConnection();
    emit(isConnected ? ConnectivityConnected() : ConnectivityDisconnected());
  }

  void _onConnectivityStatusChanged(
    ConnectivityStatusChanged event,
    Emitter<ConnectivityState> emit,
  ) async {
    final isConnected = await _connectivityService.hasInternetConnection();
    emit(isConnected ? ConnectivityConnected() : ConnectivityDisconnected());
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
