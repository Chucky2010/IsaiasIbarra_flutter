import 'package:mi_proyecto/data/noticia_repository.dart';
import 'package:mi_proyecto/domain/noticia.dart';
import 'package:mi_proyecto/constants.dart';

class NoticiaService {
  final NoticiaRepository _repository = NoticiaRepository();

  // Método para obtener noticias paginadas
  Future<List<Noticia>> getPaginatedNoticias({
    required int pageNumber,
    int pageSize = Constants.tamanoPaginaConst, // Tamaño de página predeterminado
  }) async {
    // Validaciones de los parámetros
    if (pageNumber < 1) {
      throw Exception(
        '${Constants.mensajeError}: El número de página debe ser mayor o igual a 1.',
      );
    }
    if (pageSize <= 0) {
      throw Exception(
        '${Constants.mensajeError}: El tamaño de página debe ser mayor que 0.',
      );
    }

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simula un retraso

      List<Noticia> noticias;

      // Si es la primera página, devuelve las noticias iniciales
      if (pageNumber == 1) {
        final initialNoticias = _repository.getInitialNoticias();
        if (initialNoticias.length >= pageSize) {
          noticias = initialNoticias.sublist(0, pageSize);
        } else {
          // Genera noticias adicionales si no hay suficientes
          final additionalNoticias = _repository.generateRandomNoticias(
            pageSize - initialNoticias.length,
          );
          noticias = [...initialNoticias, ...additionalNoticias];
        }
      } else {
        // Para páginas posteriores, genera nuevas noticias aleatorias
        noticias = _repository.generateRandomNoticias(pageSize);
      }

      // Validaciones adicionales para cada noticia
      for (final noticia in noticias) {
        if (noticia.titulo.isEmpty) {
          throw Exception('${Constants.mensajeError}: El título no puede estar vacío.');
        }
        if (noticia.descripcion.isEmpty) {
          throw Exception('${Constants.mensajeError}: La descripción no puede estar vacía.');
        }
        if (noticia.fuente.isEmpty) {
          throw Exception('${Constants.mensajeError}: La fuente no puede estar vacía.');
        }
        if (noticia.publicadaEl.isAfter(DateTime.now())) {
          throw Exception('${Constants.mensajeError}: La fecha de publicación no puede estar en el futuro.');
        }
      }

      // Ordena las noticias por fecha de publicación (más recientes primero)
      noticias.sort((a, b) => b.publicadaEl.compareTo(a.publicadaEl));

      return noticias;
    } catch (e) {
      throw Exception('${Constants.mensajeError}: $e');
    }
  }
}