import 'package:flutter/material.dart';

/// Widget que muestra una animación del dinosaurio de Google cuando no hay conexión a internet
class DinosaurAnimation extends StatefulWidget {
  const DinosaurAnimation({super.key});

  @override
  State<DinosaurAnimation> createState() => _DinosaurAnimationState();
}

class _DinosaurAnimationState extends State<DinosaurAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
      // Controlador para la animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // Animación principal de opacidad
    _animation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    // Animación de rebote más dinámica
    _bounceAnimation = Tween<double>(begin: -8, end: 4).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: Curves.elasticInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animación del dinosaurio
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _bounceAnimation.value / 1.5), // Más salto
                child: FadeTransition(
                  opacity: _animation,
                  child: child,
                ),
              );
            },
            child: const DinosaurFigure(),
          ),
          const SizedBox(height: 5), // Espacio reducido          // Mensaje de error compacto
          const Column(
            children: [
              Text(
                'Sin conexión',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2),
              Text(
                'Modo offline',
                style: TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Figura del dinosaurio dibujada con CustomPaint
class DinosaurFigure extends StatelessWidget {
  const DinosaurFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,  // Tamaño reducido
      height: 80, // Tamaño reducido
      child: CustomPaint(
        painter: DinosaurPainter(),
      ),
    );
  }
}

/// Painter personalizado para dibujar el dinosaurio
class DinosaurPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.fill;

    // Definir la forma mejorada del dinosaurio T-Rex
    final path = Path();
    
    // Cuerpo
    path.moveTo(size.width * 0.35, size.height * 0.55);
    path.lineTo(size.width * 0.65, size.height * 0.55);
    path.lineTo(size.width * 0.65, size.height * 0.4);
    path.lineTo(size.width * 0.35, size.height * 0.4);
    path.close();
    
    // Cabeza más detallada
    path.moveTo(size.width * 0.65, size.height * 0.45);
    path.lineTo(size.width * 0.8, size.height * 0.45);
    path.lineTo(size.width * 0.8, size.height * 0.35);
    path.lineTo(size.width * 0.75, size.height * 0.32); // Forma de la cabeza
    path.lineTo(size.width * 0.65, size.height * 0.35);
    path.close();
    
    // Boca
    path.moveTo(size.width * 0.75, size.height * 0.45);
    path.lineTo(size.width * 0.8, size.height * 0.45);
    path.lineTo(size.width * 0.8, size.height * 0.42);
    path.lineTo(size.width * 0.75, size.height * 0.42);
    path.close();
    
    // Ojo
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(size.width * 0.73, size.height * 0.37),
      size.width * 0.025,
      paint
    );
    
    paint.color = Colors.black;
    canvas.drawCircle(
      Offset(size.width * 0.73, size.height * 0.37),
      size.width * 0.01,
      paint
    );
    
    paint.color = Colors.grey.shade800;
    
    // Brazo pequeño
    path.moveTo(size.width * 0.55, size.height * 0.5);
    path.lineTo(size.width * 0.57, size.height * 0.47);
    path.lineTo(size.width * 0.53, size.height * 0.47);
    path.close();
    
    // Patas traseras (más anchas)
    path.moveTo(size.width * 0.45, size.height * 0.55);
    path.lineTo(size.width * 0.45, size.height * 0.7);
    path.lineTo(size.width * 0.38, size.height * 0.7);
    path.lineTo(size.width * 0.38, size.height * 0.55);
    path.close();
    
    // Cola
    path.moveTo(size.width * 0.35, size.height * 0.48);
    path.lineTo(size.width * 0.2, size.height * 0.48);
    path.lineTo(size.width * 0.2, size.height * 0.42);
    path.lineTo(size.width * 0.35, size.height * 0.42);
    path.close();
    
    // Cresta (opcional)
    path.moveTo(size.width * 0.5, size.height * 0.4);
    path.lineTo(size.width * 0.52, size.height * 0.35);
    path.lineTo(size.width * 0.48, size.height * 0.35);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
