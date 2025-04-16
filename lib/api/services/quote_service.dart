import 'package:mi_proyecto/data/quote_repository.dart';
import 'package:mi_proyecto/domain/quote.dart';
import 'package:mi_proyecto/constants.dart';

class QuoteService {
  final QuoteRepository _repository = QuoteRepository();

  // Método para obtener cotizaciones paginadas
  Future<List<Quote>> getPaginatedQuotes({
    required int pageNumber,
    int pageSize = pageSize, // Tamaño de página predeterminado
  }) async {
    // Validaciones de los parámetros
    if (pageNumber < 1) {
      throw Exception(
        '$errorMessage: El número de página debe ser mayor o igual a 1.',
      );
    }
    if (pageSize <= 0) {
      throw Exception(
        '$errorMessage: El tamaño de página debe ser mayor que 0.',
      );
    }

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simula un retraso

      List<Quote> quotes;

      // Si es la primera página, verifica si las cotizaciones iniciales son suficientes
      // Si no hay cotizaciones iniciales, genera nuevas cotizaciones aleatorias

      if (pageNumber == 1) {
        // Si es la primera página, verifica si las cotizaciones iniciales son suficientes
        final initialQuotes = _repository.getInitialQuotes();
        if (initialQuotes.length >= pageSize) {
          quotes = initialQuotes.sublist(0, pageSize);
        } else {
          // Genera cotizaciones adicionales si no hay suficientes
          final additionalQuotes = _repository.generateRandomQuotes(
            pageSize - initialQuotes.length,
          );
          quotes = [...initialQuotes, ...additionalQuotes];
        }
      } else {
        // Para páginas posteriores, genera nuevas cotizaciones aleatorias
        quotes = _repository.generateRandomQuotes(pageSize);
      }

      // Filtra las cotizaciones con stockPrice positivo
      final filteredQuotes =
          quotes.where((quote) => quote.stockPrice > 0).toList();

      // Validación adicional: lanza una excepción si changePercentage no está entre -100 y 100
      for (final quote in filteredQuotes) {
        if (quote.changePercentage > 100 || quote.changePercentage < -100) {
          throw Exception(
            '$errorMessage: El porcentaje de cambio debe estar entre -100 y 100. Cotización inválida: ${quote.companyName}',
          );
        }
      }

      // Ordena las cotizaciones por stockPrice de mayor a menor
      filteredQuotes.sort((a, b) => b.stockPrice.compareTo(a.stockPrice));
      
      return filteredQuotes;
    } catch (e) {
      throw Exception('$errorMessage: $e');
    }
  }
}
