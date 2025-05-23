import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/connectivity/connectivity_bloc.dart';
import 'package:mi_proyecto/bloc/connectivity/connectivity_state.dart';
import 'package:mi_proyecto/helpers/snackbar_manager.dart';

/// Widget que muestra una alerta cuando no hay conectividad a Internet usando SnackBar
/// Complementario a la animación del dinosaurio en el ConnectivityWrapper
class ConnectivityAlert extends StatelessWidget {
  const ConnectivityAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listenWhen: (previous, current) {
        // Solo actuar cuando hay un cambio real en el estado de conectividad
        return (previous is ConnectivityConnected &&
                current is ConnectivityDisconnected) ||
            (previous is ConnectivityDisconnected &&
                current is ConnectivityConnected);
      },
      listener: (context, state) {
        // Obtener la instancia del SnackBarManager
        final SnackBarManager snackBarManager = SnackBarManager();
        if (state is ConnectivityDisconnected) {
          // Ya no es necesario mostrar el SnackBar porque ahora mostramos una pantalla completa
          // Solo actualizamos el estado del manager para seguimiento interno
          snackBarManager.setConnectivitySnackBarShowing(true);
        } else if (state is ConnectivityConnected) {
          // Ocultar SnackBar cuando se recupera la conexión
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          // Marcar que ya no se está mostrando el SnackBar de conectividad
          snackBarManager.setConnectivitySnackBarShowing(false);
        }
      },
      child: const SizedBox.shrink(), // Widget invisible
    );
  }
}
