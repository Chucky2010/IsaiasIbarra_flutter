import 'package:flutter/material.dart';

/// Componente que proporciona la configuración visual del SnackBar
class SnackBarComponent {
  /// Crea y retorna un SnackBar con un estilo consistente para toda la aplicación
  static SnackBar crear({
    required String mensaje,
    required Color color,
    required Duration duracion,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    return SnackBar(      content: Text(
        mensaje,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
      duration: duracion,
      action: onAction != null && actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: Colors.white,
              onPressed: onAction,
            )
          : null,      behavior: SnackBarBehavior.fixed,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0, // Sin sombra
    );
  }
}