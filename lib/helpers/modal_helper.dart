import 'package:flutter/material.dart';

class ModalHelper {
  /// Muestra un modal bottom sheet con configuración estandarizada
  static Future<T?> mostrarModal<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    BorderRadius? borderRadius,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      shape: borderRadius != null 
          ? RoundedRectangleBorder(borderRadius: borderRadius) 
          : null,
      builder: (context) => child,
    );
  }

  /// Muestra un diálogo de alerta con configuración estandarizada
  static Future<T?> mostrarDialogo<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    String? title,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        if (title != null) {
          return AlertDialog(
            title: Text(title),
            content: child,
          );
        }
        return AlertDialog(
          content: child,
        );
      },
    );
  }
}