import 'package:mi_proyecto/data/quote_repository.dart';
import 'package:mi_proyecto/domain/quote.dart';
import 'package:mi_proyecto/constants.dart';

class QuoteService {
  final QuoteRepository _repository = QuoteRepository();

// Método para obtener todas las cotizaciones
  Future<List<Quote>> getQuotes() async {
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simula un retraso
      final quotes = await _repository.fetchAllQuotes();

      // Validación adicional: changePercentage debe estar entre -100 y 100
      for (var quote in quotes) {
        if (quote.changePercentage < -100 || quote.changePercentage > 100) {
          throw Exception('$errorMessage: El porcentaje de cambio debe estar entre -100 y 100.');
        }
      }

      return quotes;
    } catch (e) {
      throw Exception('$errorMessage: $e');
    }
  }

    // Método para obtener una cotización aleatoria
  Future<Quote> getRandomQuote() async {
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simula un retraso
      final quote = await _repository.fetchRandomQuote();

      // Validación adicional: changePercentage debe estar entre -100 y 100
      if (quote.changePercentage < -100 || quote.changePercentage > 100) {
        throw Exception('$errorMessage: El porcentaje de cambio debe estar entre -100 y 100.');
      }

      return quote;
    } catch (e) {
      throw Exception('$errorMessage: $e');
    }
  }
  // Método para obtener cotizaciones paginadas
  Future<List<Quote>> getPaginatedQuotes({
    required int pageNumber,
    int pageSize = pageSize,
  }) async {
    // Validaciones de los parámetros
    if (pageNumber < 1) {
      throw Exception('Error: El número de página debe ser mayor o igual a 1.');
    }
    if (pageSize <= 0) {
      throw Exception('Error: El tamaño de página debe ser mayor que 0.');
    }

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simula un retraso

      // Obtiene todas las cotizaciones del repositorio
      final allQuotes = await _repository.fetchAllQuotes();

      // Filtra las cotizaciones con stockPrice positivo
      final filteredQuotes = allQuotes.where((quote) {
        if (quote.changePercentage < -100 || quote.changePercentage > 100) {
          throw Exception('$errorMessage: El porcentaje de cambio debe estar entre -100 y 100.');
        }
        return quote.stockPrice > 0;
      }).toList();

      // Ordena las cotizaciones por stockPrice de mayor a menor
      filteredQuotes.sort((a, b) => b.stockPrice.compareTo(a.stockPrice));

      // Calcula el índice inicial y final para la paginación
      final startIndex = (pageNumber - 1) * pageSize;
      final endIndex = startIndex + pageSize;

      // Devuelve las cotizaciones paginadas
      if (startIndex >= filteredQuotes.length) {
        return []; // Si el índice inicial está fuera de rango, devuelve una lista vacía
      }
      return filteredQuotes.sublist(
        startIndex,
        endIndex > filteredQuotes.length ? filteredQuotes.length : endIndex,
      );
    } catch (e) {
      throw Exception('$errorMessage: $e');
    }
  }
}