import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/data/quote_repository.dart';
import 'package:mi_proyecto/domain/quote.dart';

class QuoteService {
  final QuoteRepository _repository = QuoteRepository();

  // Método para obtener todas las cotizaciones
  Future<List<Quote>> getAllQuotes() {
    return _repository.fetchAllQuotes();
  }

  // Método para obtener una cotización aleatoria
  Future<Quote> getRandomQuote() {
    return _repository.fetchRandomQuote();
  }

  // Método para obtener cotizaciones paginadas
  Future<List<Quote>> getPaginatedQuotes({
    required int pageNumber,
    int pageSize = CotizacionConstantes.pageSize
  }) async {
    // Validaciones
    if (pageNumber < 1) {
      throw Exception('El número de página debe ser mayor o igual a 1.');
    }
    if (pageSize <= 0) {
      throw Exception('El tamaño de página debe ser mayor que 0.');
    }

    // Llama al método del repository para obtener las cotizaciones paginadas
    final quotes = await _repository.getPaginatedQuotes(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );

    // Validación adicional: changePercentage debe estar entre -100 y 100
    for (final quote in quotes) {
      if (quote.changePercentage > 100 || quote.changePercentage < -100) {
        throw Exception('El porcentaje de cambio debe estar entre -100 y 100.');
      }
    }

    // Filtra las cotizaciones con stockPrice positivo
    final filteredQuotes = quotes.where((quote) => quote.stockPrice > 0).toList();

    // Ordena las cotizaciones por stockPrice de mayor a menor
    filteredQuotes.sort((a, b) => b.stockPrice.compareTo(a.stockPrice));

    // Simula un delay adicional para consistencia
    await Future.delayed(const Duration(seconds: 2));

    return filteredQuotes;
  }
}