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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFFCEAE8), // Color rosa suave
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 70.0,
        vertical: 24.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.info_outline,
              color: Colors.blue,
              size: 40,
            ),
            const SizedBox(height: 12),
            const Text(
              'Noticia ya reportada',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Esta noticia ya ha sido reportada por varios usuarios y está siendo revisada.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Entendido',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}