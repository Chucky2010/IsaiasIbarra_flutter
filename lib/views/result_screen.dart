import 'package:flutter/material.dart';
import 'package:mi_proyecto/constants.dart';
import 'package:mi_proyecto/views/start_screen.dart';

class ResultScreen extends StatelessWidget {
  final int finalScore; // Puntaje final
  final int totalQuestions; // Total de preguntas

  const ResultScreen({
    super.key,
    required this.finalScore,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    // Texto del puntaje
    final String scoreText = '$AppConstants.finalScore $finalScore/$totalQuestions';

    // Mensaje de retroalimentación
    final String feedbackMessage = finalScore > (totalQuestions / 2)
        ? '¡Buen trabajo!'
        : '¡Sigue practicando!';

    // Estilo del texto del puntaje
    const TextStyle scoreTextStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

  // Espaciado entre elementos
    const double spacingHeight = 20.0;

    // Color del botón
    final Color buttonColor = finalScore > (totalQuestions / 2)
        ? Colors.blue // Azul si el puntaje es mayor a la mitad
        : Colors.green; // Verde si es menor o igual a la mitad


    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      appBar: AppBar(
        title: const Text(AppConstants.titleAppGame), // Título de la aplicación
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                scoreText, // Muestra el puntaje
                style: scoreTextStyle,
                textAlign: TextAlign.center,
              ),
             const SizedBox(height: spacingHeight), // Espaciado entre puntaje y mensaje
              Text(
                feedbackMessage, // Mensaje de retroalimentación
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24), // Espaciado antes del botón
              ElevatedButton(
                onPressed: () {
                  // Navega de vuelta a StartScreen y reinicia el juego
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const StartScreen()),
                    (route) => false, // Elimina todas las rutas anteriores
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, // Botón verde
                  foregroundColor: Colors.white, // Texto blanco
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0,
                  ),
                ),
                child: const Text(AppConstants.playAgain), // Texto del botón
              ),
            ],
          ),
        ),
      ),
    );
  }
}