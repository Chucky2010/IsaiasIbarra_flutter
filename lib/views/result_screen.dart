import 'package:flutter/material.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/views/start_screen.dart';

class ResultScreen extends StatelessWidget {
  final int finalScoreGame;
  final int totalQuestions;

  const ResultScreen({super.key, required this.finalScoreGame, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double spacingHeight = 16;

    // Variable para mostrar el puntaje final
    final String scoreText = '$PreguntasConstantes.finalScore: $finalScoreGame/$totalQuestions';

    // Mensaje de retroalimentación
    final String feedbackMessage = finalScoreGame > (totalQuestions / 2)
        ? '¡Buen trabajo!'
        : '¡Sigue practicando!';

    // Determina el color del botón basado en el puntaje y al mismo tiempo respetando el tema
    final Color buttonColor = finalScoreGame > (totalQuestions / 2)
        ? theme.colorScheme.primary // Color primario del tema si el puntaje es mayor a la mitad
        : Colors.green; // Verde en caso contrario (siempre es un buen color para "intentarlo de nuevo")

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¡Juego Terminado!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                scoreText,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: spacingHeight),
              Text(
                feedbackMessage,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const StartScreen()),
                    (route) => false, // Elimina todas las rutas anteriores
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, 
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  PreguntasConstantes.playAgain,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}