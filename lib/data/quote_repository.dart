import 'dart:math'; // Importa para generar números aleatorios
import 'package:mi_proyecto/domain/quote.dart';
import 'package:mi_proyecto/constants.dart';

class QuoteRepository {
  static final List<Quote> _initialQuotes = [
    Quote(
      companyName: 'Apple',
      stockPrice: 150.25,
      changePercentage: 2.5,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 1)), // Hace 1 hora
    ),
    Quote(
      companyName: 'Google',
      stockPrice: 2800.50,
      changePercentage: -1.2,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 2)), // Hace 2 horas
    ),
    Quote(
      companyName: 'Amazon',
      stockPrice: 3400.75,
      changePercentage: 0.8,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 3)), // Hace 3 horas
    ),
    Quote(
      companyName: 'Microsoft',
      stockPrice: 299.99,
      changePercentage: 1.5,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 4)), // Hace 4 horas
    ),
    Quote(
      companyName: 'Tesla',
      stockPrice: 720.10,
      changePercentage: -0.7,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 5)), // Hace 5 horas
    ),

  
  ];

// Lista de nombres de empresas conocidas
  static final List<String> _companyNames = [
    'Apple',
    'Google',
    'Amazon',
    'Microsoft',
    'Tesla',
    'Meta',
    'Netflix',
    'Samsung',
    'Intel',
    'NVIDIA',
    'Adobe',
    'IBM',
    'Oracle',
    'Spotify',
    'Twitter',
    'Coca-Cola',
    'Pepsi',
    'Nike',
    'Adidas',
    'Starbucks',
  ];

  // Método para obtener las cotizaciones iniciales
  List<Quote> getInitialQuotes() {
    return List.unmodifiable(_initialQuotes); // Devuelve una copia inmutable
  }

  // Método para generar cotizaciones aleatorias
  List<Quote> generateRandomQuotes(int count) {
    final random = Random();
    return List.generate(count, (index) {
      final companyName = _companyNames[random.nextInt(_companyNames.length)];
      final stockPrice = random.nextDouble() * 1000 + 50; // Precio entre 50 y 1050
      final changePercentage = random.nextDouble() * 20 - 10; // Cambio entre -10% y 10%
      return Quote(
        companyName: companyName,
        stockPrice: stockPrice,
        changePercentage: changePercentage,
        lastUpdated: DateTime.now(),
      );
    });
  }

  
}


