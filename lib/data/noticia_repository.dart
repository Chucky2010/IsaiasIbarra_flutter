import 'package:kgaona/api/service/noticia_service.dart';
import 'package:kgaona/core/base_repository.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/exceptions/api_exception.dart';

/// Repositorio para gestionar operaciones relacionadas con las noticias.
/// Extiende BaseRepository para aprovechar la gestión de errores estandarizada.
class NoticiaRepository extends BaseRepository<Noticia> {
  final NoticiaService _noticiaService = NoticiaService();

  @override
  void validarEntidad(Noticia noticia) {
    validarNoVacio(noticia.titulo, 'título de la noticia');
    validarNoVacio(noticia.descripcion, 'descripción de la noticia');
    validarNoVacio(noticia.fuente, 'fuente de la noticia');
    
    // Validación adicional para la fecha
    if (noticia.publicadaEl.isAfter(DateTime.now())) {
      throw ApiException(
        'La fecha de publicación no puede estar en el futuro.',
        statusCode: 400
      );
    }
  }
  /// Obtiene todas las noticias desde el repositorio
  Future<List<Noticia>> obtenerNoticias() async {
    return manejarExcepcion(
      () => _noticiaService.obtenerNoticias(),
      mensajeError: 'Error al obtener noticias'
    );
  }

  /// Crea una nueva noticia
  Future<void> crearNoticia(Noticia noticia) async {
    return manejarExcepcion(() {
      validarEntidad(noticia);
      return _noticiaService.crearNoticia(noticia);
    }, mensajeError: 'Error al crear noticia');
  }
  /// Edita una noticia existente
  Future<void> editarNoticia(Noticia noticia) async {
    return manejarExcepcion(() {
      validarEntidad(noticia);
      return _noticiaService.editarNoticia(noticia);
    }, mensajeError: 'Error al editar noticia');
  }

  /// Elimina una noticia
  Future<void> eliminarNoticia(String id) async {
    return manejarExcepcion(() {
      validarId(id);
      return _noticiaService.eliminarNoticia(id);
    }, mensajeError: 'Error al eliminar noticia');
  }
}
