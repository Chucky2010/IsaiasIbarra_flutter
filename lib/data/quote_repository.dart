import 'dart:math'; // Importa para generar números aleatorios
import 'package:mi_proyecto/domain/quote.dart';

class QuoteRepository {
  static final List<Quote> quotes = [
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

  // Método asíncrono para obtener todas las cotizaciones simulando una consulta REST
  Future<List<Quote>> fetchAllQuotes() async {
    await Future.delayed(const Duration(seconds: 2)); // Simula un retraso de carga
    return List.from(quotes); // Devuelve una copia de la lista de cotizaciones
  }

  // Método para obtener una cotización aleatoria
  Future<Quote> fetchRandomQuote() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simula un retraso
    final randomIndex = Random().nextInt(quotes.length); // Genera un índice aleatorio
    return quotes[randomIndex]; // Devuelve una cotización aleatoria
  }
}
