import 'package:flutter/material.dart';

/// Diálogo que se muestra cuando una noticia ha alcanzado el límite de reportes
class LimiteReportesDialog extends StatelessWidget {
  /// Constructor del diálogo de límite de reportes
  const LimiteReportesDialog({super.key});

  /// Método estático para mostrar el diálogo directamente
  static Future<void> mostrar(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const LimiteReportesDialog(),
    );
  }
  @override
  Widget build(BuildContext context) {
    // Obtener el tema actual para adaptar colores y estilos
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // Adaptar el color según el modo oscuro/claro
      backgroundColor: isDark 
          ? theme.cardColor 
          : const Color(0xFFFCEAE8), // Color rosa suave en modo claro, color de tarjeta en modo oscuro
      // Agregar elevación adecuada según el modo
      elevation: isDark ? 8 : 2,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 70.0,
        vertical: 24.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline,
              color: theme.colorScheme.primary, // Color primario del tema
              size: 40,
            ),            const SizedBox(height: 12),
            Text(
              'Noticia ya reportada',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Esta noticia ya ha sido reportada por varios usuarios y está siendo revisada.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              // Usar el estilo propio del tema para el botón
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
              child: Text(
                'Entendido',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}