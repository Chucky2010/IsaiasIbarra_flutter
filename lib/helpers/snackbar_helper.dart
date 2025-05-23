import 'package:flutter/material.dart';
import 'package:mi_proyecto/components/snackbar_component.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';
import 'package:mi_proyecto/helpers/error_helper.dart';
import 'package:mi_proyecto/helpers/snackbar_manager.dart';

class SnackBarHelper {
  /// Muestra un mensaje de éxito
  static void mostrarExito(
    BuildContext context, {
    required String mensaje,
  }) async {
    // Verificar si se puede mostrar el SnackBar (no hay mensajes de conectividad)
    if (!SnackBarManager().canShowSnackBar()) return;

    _mostrarSnackBar(
      context,
      mensaje: mensaje,
      color: Colors.green,
      duracion: const Duration(seconds: 3),
    );
    return Future.delayed(const Duration(milliseconds: 1500));
  }

  /// Muestra un mensaje informativo
  static void mostrarInfo(BuildContext context, {required String mensaje}) {
    // Verificar si se puede mostrar el SnackBar (no hay mensajes de conectividad)
    if (!SnackBarManager().canShowSnackBar()) return;

    _mostrarSnackBar(
      context,
      mensaje: mensaje,
      color: Colors.blue,
      duracion: const Duration(seconds: 3),
    );
  }

  /// Muestra un mensaje de advertencia
  static void mostrarAdvertencia(
    BuildContext context, {
    required String mensaje,
  }) {
    // Verificar si se puede mostrar el SnackBar (no hay mensajes de conectividad)
    if (!SnackBarManager().canShowSnackBar()) return;

    _mostrarSnackBar(
      context,
      mensaje: mensaje,
      color: Colors.orange,
      duracion: const Duration(seconds: 4),
    );
  }

  /// Muestra un mensaje de error
  static void mostrarError(BuildContext context, {required String mensaje}) {
    // Verificar si se puede mostrar el SnackBar (no hay mensajes de conectividad)
    if (!SnackBarManager().canShowSnackBar()) return;

    _mostrarSnackBar(
      context,
      mensaje: mensaje,
      color: Colors.red,
      duracion: const Duration(seconds: 4),
    );
  }

  /// Procesa y muestra errores teniendo en cuenta el tipo de error
  static void manejarError(
    BuildContext context,
    ApiException e, {
    Duration? duration,
    bool isConnectivityMessage =
        false, // Indica si es un mensaje de conectividad
  }) {
    if (!context.mounted) return;

    // Si no es un mensaje de conectividad y ya hay uno mostrándose, no mostrar nada
    if (!isConnectivityMessage && !SnackBarManager().canShowSnackBar()) return;

    // Usar ErrorHelper para procesar el error si es ApiException, 
    //si no recibe un codigo le pasa 0
    final color = ErrorHelper.getErrorColor(e.statusCode ?? 0);
    final mensaje = e.message;

    _mostrarSnackBar(
      context,
      mensaje: mensaje,
      color: color,
      duracion: duration ?? const Duration(seconds: 5),
      isConnectivityMessage: isConnectivityMessage,
    );
  }

  /// Método privado para mostrar el SnackBar usando el componente estándar
  static void _mostrarSnackBar(
    BuildContext context, {
    required String mensaje,
    required Color color,
    required Duration duracion,
    bool isConnectivityMessage =
        false, // Indica si es un mensaje de conectividad
  }) {
    if (!context.mounted) return;

    // Si es un mensaje de conectividad, actualizar el estado del manager
    if (isConnectivityMessage) {
      SnackBarManager().setConnectivitySnackBarShowing(true);
    }

    // Limpia cualquier SnackBar que esté mostrándose actualmente
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Muestra el nuevo SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBarComponent.crear(
        mensaje: mensaje,
        color: color,
        duracion: duracion,
      ),
    );
  }
}
