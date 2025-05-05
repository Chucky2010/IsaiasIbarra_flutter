import 'package:flutter/material.dart';
import 'package:mi_proyecto/constants.dart';
import 'package:mi_proyecto/views/game_screen.dart';


class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.titleAppGame), // Título de la aplicación
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const Text(
              AppConstants.welcomeMessage, // Mensaje de bienvenida
              style:  TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla del juego
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Cambia el color del botón a azul
              ),
              child: const Text(AppConstants.startGame),
               // Texto del botón
            ),
          ],
        ),
      ),
    );
  }
}