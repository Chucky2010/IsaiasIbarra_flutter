import 'dart:math';
import 'package:mi_proyecto/domain/noticia.dart';

class NoticiaRepository {
  // Lista de noticias iniciales
  static final List<Noticia> _initialNoticias = [
    Noticia(
      titulo: 'Flutter 3.0: Nuevas características',
      descripcion: 'Explora las nuevas características de Flutter 3.0.',
      fuente: 'TechCrunch',
      publicadaEl: DateTime.now().subtract(const Duration(hours: 1)),
      imageUrl: 'https://picsum.photos/seed/flutter3/400/200', // URL de la imagen 
    ),
    Noticia(
      titulo: 'Dart 3.0: Mejoras en el rendimiento',
      descripcion: 'Dart 3.0 trae mejoras significativas en el rendimiento.',
      fuente: 'Medium',
      publicadaEl: DateTime.now().subtract(const Duration(hours: 2)),
      imageUrl: 'https://picsum.photos/seed/dart3/400/200', // URL de la imagen    
    ),
    Noticia(
      titulo: 'Clean Architecture en Flutter',
      descripcion: 'Aprende cómo implementar Clean Architecture en Flutter.',
      fuente: 'Dev.to',
      publicadaEl: DateTime.now().subtract(const Duration(hours: 3)),
      imageUrl: 'https://picsum.photos/seed/cleanarchitecture/400/200', // URL de la imagen   
    ),
    Noticia(
      titulo: 'State Management: Bloc vs Provider',
      descripcion: 'Comparativa entre Bloc y Provider para Flutter.',
      fuente: 'Flutter Weekly',
      publicadaEl: DateTime.now().subtract(const Duration(hours: 4)),
      imageUrl: 'https://picsum.photos/seed/statemanagement/400/200', // URL de la imagen
    ),
    Noticia(
      titulo: 'Async Programming en Dart',
      descripcion: 'Guía completa sobre programación asíncrona en Dart.',
      fuente: 'TechRadar',
      publicadaEl: DateTime.now().subtract(const Duration(hours: 5)),
      imageUrl: 'https://picsum.photos/seed/asyncprogramming/400/200', // URL de la imagen
    ),
    Noticia(
      titulo: 'Mejoras en Flutter Web',
      descripcion: 'Nuevas optimizaciones para Flutter Web.',
      fuente: 'Hacker News',
      publicadaEl: DateTime.now().subtract(const Duration(hours: 6)),
      imageUrl: 'https://picsum.photos/seed/flutterweb/400/200', // URL de la imagen
    ),
    Noticia(
      titulo: 'Flutter para aplicaciones de escritorio',
      descripcion: 'Cómo usar Flutter para crear aplicaciones de escritorio.',
      fuente: 'Reddit',
      publicadaEl: DateTime.now().subtract(const Duration(hours: 7)),
      imageUrl: 'https://picsum.photos/seed/flutterdesktop/400/200', // URL de la imagen
    ),
    Noticia(
      titulo: 'Introducción a Riverpod',
      descripcion: 'Una guía para empezar con Riverpod en Flutter.',
      fuente: 'Smashing Magazine',
      publicadaEl: DateTime.now().subtract(const Duration(hours: 8)),
      imageUrl: 'https://picsum.photos/seed/riverpod/400/200', // URL de la imagen
    ),
    Noticia(
      titulo: 'Flutter y Firebase: Integración completa',
      descripcion: 'Cómo integrar Firebase con Flutter.',
      fuente: 'Google Blog',
      publicadaEl: DateTime.now().subtract(const Duration(hours: 9)),
      imageUrl: 'https://picsum.photos/seed/flutterfirebase/400/200', // URL de la imagen
    ),
    Noticia(
      titulo: 'Diseño responsivo en Flutter',
      descripcion: 'Consejos para crear diseños responsivos en Flutter.',
      fuente: 'Flutter Community',
      publicadaEl: DateTime.now().subtract(const Duration(hours: 10)),
      imageUrl: 'https://picsum.photos/seed/responsivedesign/400/200', // URL de la imagen
    ),
    Noticia(
      titulo: 'Nuevas herramientas para Flutter',
      descripcion: 'Descubre las últimas herramientas para Flutter.',
      fuente: 'GitHub',
      publicadaEl: DateTime.now().subtract(const Duration(hours: 11)),
      imageUrl: 'https://picsum.photos/seed/fluttertools/400/200', // URL de la imagen
     ),
    Noticia(
      titulo: 'Flutter 3.1: Qué esperar',
      descripcion: 'Un vistazo a las próximas actualizaciones de Flutter.',
      fuente: 'TechCrunch',
      publicadaEl: DateTime.now().subtract(const Duration(hours: 12)),
      imageUrl: 'https://picsum.photos/seed/flutter31/400/200', // URL de la imagen   
    ),
    Noticia(
      titulo: 'Optimización de rendimiento en Flutter',
      descripcion: 'Cómo optimizar el rendimiento de tus aplicaciones Flutter.',
      fuente: 'Medium',
      publicadaEl: DateTime.now().subtract(const Duration(hours: 13)),
      imageUrl: 'https://picsum.photos/seed/performance/400/200', // URL de la imagen
     ),
    Noticia(
      titulo: 'Flutter y la inteligencia artificial',
      descripcion: 'Cómo usar Flutter para proyectos de IA.',
      fuente: 'Dev.to',
      publicadaEl: DateTime.now().subtract(const Duration(hours: 14)),
      imageUrl: 'https://picsum.photos/seed/flutterai/400/200', // URL de la imagen
    ),
    Noticia(
      titulo: 'Nuevas librerías para Flutter',
      descripcion: 'Explora las últimas librerías para Flutter.',
      fuente: 'Flutter Weekly',
      publicadaEl: DateTime.now().subtract(const Duration(hours: 15)),
      imageUrl: 'https://picsum.photos/seed/flutterlibs/400/200', // URL de la imagen
    ),
  ];

  // Lista de fuentes de noticias conocidas
  static final List<String> _fuentes = [
    'TechCrunch',
    'Medium',
    'Dev.to',
    'Flutter Weekly',
    'TechRadar',
    'Hacker News',
    'Reddit',
    'Smashing Magazine',
    'Google Blog',
    'Flutter Community',
    'GitHub',
  ];

  // Método para obtener las noticias iniciales
  List<Noticia> getInitialNoticias() {
    return List.unmodifiable(_initialNoticias); // Devuelve una copia inmutable
  }

  // Método para generar noticias aleatorias
  List<Noticia> generateRandomNoticias(int count) {
    final random = Random();
    return List.generate(count, (index) {
      final titulo = _fuentes[random.nextInt(_fuentes.length)];
      final descripcion = 'Descripción de la noticia aleatoria ${random.nextInt(1000)}';
      final fuente = _fuentes[random.nextInt(_fuentes.length)];
      final publicadaEl = DateTime.now().subtract(Duration(hours: random.nextInt(48))); // Últimas 48 horas
      final imageUrl = 'https://picsum.photos/seed/${titulo.hashCode}/400/200'; // Genera la URL de la imagen
      return Noticia(
        titulo: titulo,
        descripcion: descripcion,
        fuente: fuente,
        publicadaEl: publicadaEl,
        imageUrl: imageUrl, // Pasa la URL generada al modelo
      );
    });
  }
}