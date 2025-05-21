import 'package:flutter/material.dart';
import 'package:kgaona/components/dinosaur_animation.dart';

/// Pantalla completa que se muestra cuando no hay conectividad a internet
class NoConnectivityScreen extends StatelessWidget {
  const NoConnectivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono de wifi con una línea cruzada
            Icon(
              Icons.wifi_off,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 40),
            
            // Animación del dinosaurio
            const SizedBox(
              height: 200,
              width: 200,
              child: DinosaurAnimation(),
            ),
            
            const SizedBox(height: 40),
            
            // Mensaje de error principal
            Text(
              '¡Sin conexión a Internet!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Mensaje secundario
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Por favor, verifica tu conexión a internet e inténtalo nuevamente.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Botón para reintentar (opcional)
            ElevatedButton.icon(
              onPressed: () {
                // Aquí se podría agregar lógica para verificar manualmente la conectividad
                final snackBar = const SnackBar(
                  content: Text('Verificando conexión...'),
                  duration: Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
