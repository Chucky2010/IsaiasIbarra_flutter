import 'package:flutter/material.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/views/start_screen.dart';

class ResultScreen extends StatelessWidget {
  final int finalScoreGame;
  final int totalQuestions;

  const ResultScreen({super.key, required this.finalScoreGame, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {

    const double spacingHeight = 16;

    // Variable para mostrar el puntaje final
    final String scoreText = '$PreguntasConstantes.finalScore: $finalScoreGame/$totalQuestions';

    // Mensaje de retroalimentación
    final String feedbackMessage = finalScoreGame > (totalQuestions / 2)
        ? '¡Buen trabajo!'
        : '¡Sigue practicando!';

    // Estilo del texto del puntaje
    const TextStyle scoreTextStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    // Estilo del mensaje de retroalimentación
    const TextStyle feedbackTextStyle = TextStyle(
      fontSize: 18,
      color: Colors.grey,
    );

    // Determina el color del botón
    final Color buttonColor = finalScoreGame > (totalQuestions / 2)
        ? Colors.blue // Azul si el puntaje es mayor a la mitad
        : Colors.green; // Verde en caso contrario

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '¡Juego Terminado!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                scoreText,
                style: scoreTextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: spacingHeight),
              Text(
                feedbackMessage,
                style: feedbackTextStyle,
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
                  backgroundColor: buttonColor,// Usa la variable buttonColor
                  foregroundColor: Colors.white,
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