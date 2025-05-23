import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/connectivity/connectivity_bloc.dart';
import 'package:mi_proyecto/bloc/connectivity/connectivity_state.dart';
import 'package:mi_proyecto/components/connectivity_alert.dart';
import 'package:mi_proyecto/components/no_connectivity_screen.dart';

/// Widget que envuelve la aplicación y muestra una alerta de conectividad cuando es necesario
class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({
    super.key,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        // Si no hay conexión, mostrar la pantalla completa del dinosaurio
        if (state is ConnectivityDisconnected) {
          return const NoConnectivityScreen();
        }
        
        // Si hay conexión, mostrar el contenido normal con el ConnectivityAlert
        return Stack(
          children: [
            // Contenido principal de la aplicación
            child,
            
            // Widget invisible que escucha cambios de conectividad
            const ConnectivityAlert(),
          ],
        );
      },    );
  }
}
