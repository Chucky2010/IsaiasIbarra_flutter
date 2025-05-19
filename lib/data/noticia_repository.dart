import 'package:mi_proyecto/api/service/noticia_sevice.dart';
import 'package:mi_proyecto/data/base_repository.dart';
import 'package:mi_proyecto/domain/noticia.dart';
import 'package:mi_proyecto/constants.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

class NoticiaRepository extends BaseRepository {
  final NoticiaService _service = NoticiaService();
  /// Obtiene noticias con validaciones
  Future<List<Noticia>> obtenerNoticias() async {
    return executeWithTryCatch(
      () async {
        final noticias = await _service.obtenerNoticias();
        return validateListNotEmpty(
          noticias,
          'No se encontraron noticias disponibles',
        );
      },
      'obtener noticias',
    );
  }
  Future<void> crearNoticia({
    required String titulo,
    required String descripcion,
    required String fuente,
    required DateTime publicadaEl,
    required String urlImagen,
    required String categoriaId,
  }) async {
    final noticia = Noticia(
      titulo: titulo,
      descripcion: descripcion,
      fuente: fuente,
      publicadaEl: publicadaEl,
      urlImagen: urlImagen,
      categoriaId: categoriaId,
    );
    
    return executeWithTryCatch(
      () => _service.crearNoticia(noticia),
      'crear noticia',
    );
  }
  Future<void> eliminarNoticia(String id) async {
    if (id.isEmpty) {
      throw Exception(
        '${NoticiaConstantes.mensajeError} El ID de la noticia no puede estar vacío.',
      );
    }
    
    return executeWithTryCatch(
      () => _service.eliminarNoticia(id),
      'eliminar noticia',
    );
  }
  Future<void> actualizarNoticia({
    required String id,
    required String titulo,
    required String descripcion,
    required String fuente,
    required DateTime publicadaEl,
    required String urlImagen,
    required String categoriaId,
  }) async {
    if (titulo.isEmpty || descripcion.isEmpty || fuente.isEmpty) {
      throw ApiException(
        'Los campos título, descripción y fuente no pueden estar vacíos.',
      );
    }
    final noticia = Noticia(
      titulo: titulo,
      descripcion: descripcion,
      fuente: fuente,
      publicadaEl: publicadaEl,
      urlImagen: urlImagen,
      categoriaId: categoriaId,
    );
    
    return executeWithTryCatch(
      () => _service.actualizarNoticia(id, noticia),
      'actualizar noticia',
    );
  }
}