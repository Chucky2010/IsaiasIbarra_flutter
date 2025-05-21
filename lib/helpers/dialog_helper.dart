import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/auth/auth_bloc.dart';
import 'package:kgaona/bloc/auth/auth_event.dart';
import 'package:kgaona/data/preferencia_repository.dart';
import 'package:kgaona/views/login_screen.dart';
import 'package:get_it/get_it.dart';

/// Helper para gestionar diferentes tipos de diálogos en la aplicación
class DialogHelper {

  /// Muestra un diálogo de confirmación genérico
  static Future<bool?> mostrarConfirmacion({
    required BuildContext context, 
    required String titulo, 
    required String mensaje,
    String textoCancelar = 'Cancelar',
    String textoConfirmar = 'Confirmar',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(textoCancelar),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(textoConfirmar),
            ),
          ],
        );
      },
    );
  }  /// Muestra un diálogo específico para cerrar sesión
  static void mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Cerramos primero el diálogo
                Navigator.of(context).pop();
                
                // Usar el BLoC para manejar el cierre de sesión
                // Esto invocará internamente al AuthRepository.logout()
                // que se encargará de limpiar los tokens y datos de sesión
                BlocProvider.of<AuthBloc>(context).add(AuthLogoutRequested());
                
                // Redireccionar a la pantalla de login, eliminando todas las pantallas del stack
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false, // Elimina todas las rutas previas
                );
                
                // Obtener instancia del PreferenciaRepository para limpiar la caché
                final preferenciasRepo = GetIt.instance<PreferenciaRepository>();
                
                // Invalidamos la caché de preferencias
                preferenciasRepo.invalidarCache();
              },
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }
}