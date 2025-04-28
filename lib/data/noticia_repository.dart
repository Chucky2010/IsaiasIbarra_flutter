import 'package:mi_proyecto/api/services/noticia_service.dart';
import 'package:mi_proyecto/domain/noticia.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';


class NoticiaRepository {
  final NoticiaService _service = NoticiaService();


  Future<void> createNoticia(Noticia noticia) async {
   
    try {
       await _service.createNoticia(noticia);
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        throw Exception('Error en el servicio de noticias: ${e.message}');
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  Future<List<Noticia>> getPaginatedNoticias({
  required int pageNumber,
  required int pageSize,
}) async {
  try{
      return await _service.fetchNoticiasFromApi(pageNumber, pageSize);
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  // final noticias = await _repository.fetchNoticiasFromApi(pageNumber, pageSize);
  
  // return noticias;
}

Future<void> updateNoticia(Noticia noticia) async {
    await _service.updateNoticia(noticia);
  }

  Future<void> deleteNoticia(String id) async {
    await _service.deleteNoticia(id);
  }

}
