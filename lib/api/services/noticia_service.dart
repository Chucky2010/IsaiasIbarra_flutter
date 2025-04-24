import 'package:mi_proyecto/data/noticia_repository.dart';
import 'package:mi_proyecto/domain/noticia.dart';
import 'package:mi_proyecto/constants.dart';

class NoticiaService {
  final NoticiaRepository _repository = NoticiaRepository();


  Future<List<Noticia>> getNoticias({
    required int pageNumber,
    required int pageSize,
  }) async {
    return await _repository.fetchNoticiasFromApi(pageNumber, pageSize);
  }

  Future<void> createNoticia(Noticia noticia) async {
    await _repository.createNoticia(noticia);
  }

  Future<List<Noticia>> getPaginatedNoticias({
  required int pageNumber,
  required int pageSize,
}) async {
  final noticias = await _repository.fetchNoticiasFromApi(pageNumber, pageSize);
  print('Noticias devueltas por el repositorio: ${noticias.length}');
  return noticias;
}

Future<void> updateNoticia(Noticia noticia) async {
    await _repository.updateNoticia(noticia);
  }

  Future<void> deleteNoticia(String id) async {
    await _repository.deleteNoticia(id);
  }



  // Método para obtener noticias paginadas desde la API
  // Future<List<Noticia>> getPaginatedNoticias({
  //   required int pageNumber,
  //   int pageSize = Constants.tamanoPaginaConst, // Tamaño de página predeterminado
  //    required bool ordenarPorFecha, // Nuevo parámetro para el criterio de ordenamiento
  // }) async {
  //   // Validaciones de los parámetros
  //   if (pageNumber < 1) {
  //     throw Exception(
  //       '${Constants.mensajeError}: El número de página debe ser mayor o igual a 1.',
  //     );
  //   }
  //   if (pageSize <= 0) {
  //     throw Exception(
  //       '${Constants.mensajeError}: El tamaño de página debe ser mayor que 0.',
  //     );
  //   }

  //   try {
  //     await Future.delayed(const Duration(seconds: 2)); // Simula un retraso

  //     // Obtiene noticias desde la API
  //     final noticias = await _repository.fetchNoticiasFromApi(pageNumber, pageSize);

  //     // Validaciones adicionales para cada noticia
  //     for (final noticia in noticias) {
  //       if (noticia.titulo.isEmpty) {
  //         throw Exception('${Constants.mensajeError}: El título no puede estar vacío.');
  //       }
  //       if (noticia.descripcion.isEmpty) {
  //         throw Exception('${Constants.mensajeError}: La descripción no puede estar vacía.');
  //       }
  //       if (noticia.fuente.isEmpty) {
  //         throw Exception('${Constants.mensajeError}: La fuente no puede estar vacía.');
  //       }
  //       if (noticia.publicadaEl.isAfter(DateTime.now())) {
  //         throw Exception('${Constants.mensajeError}: La fecha de publicación no puede estar en el futuro.');
  //       }
  //     }

  //     // Ordena las noticias según el criterio seleccionado
  //   if (ordenarPorFecha) {
  //     noticias.sort((a, b) => b.publicadaEl.compareTo(a.publicadaEl)); // Más recientes primero
  //   } else {
  //     noticias.sort((a, b) => a.fuente.compareTo(b.fuente)); // Orden alfabético por fuente
  //   }
  //     return noticias;
  //   } catch (e) {
  //     throw Exception('${Constants.mensajeError}: $e');
  //   }
  // }
}
