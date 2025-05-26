import 'package:mi_proyecto/api/service/noticia_service.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/data/base_repository.dart';
import 'package:mi_proyecto/data/reporte_repository.dart';
import 'package:mi_proyecto/domain/noticia.dart';

/// Repositorio para gestionar operaciones relacionadas con las noticias.
/// Extiende BaseRepository para aprovechar la gestión de errores estandarizada.
class NoticiaRepository extends BaseRepository<Noticia> {
  final NoticiaService _noticiaService = NoticiaService();
  final reporteRepo = ReporteRepository();

  @override
  void validarEntidad(Noticia noticia) {
    validarNoVacio(noticia.titulo, ValidacionConstantes.tituloNoticia);
    validarNoVacio(
      noticia.descripcion,
      ValidacionConstantes.descripcionNoticia,
    );
    validarNoVacio(noticia.fuente, ValidacionConstantes.fuenteNoticia);

    // Validación adicional para la fecha usando el método genérico
    validarFechaNoFutura(
      noticia.publicadaEl,
      ValidacionConstantes.fechaNoticia,
    );
  }

  /// Obtiene todas las noticias desde el repositorio
  Future<List<Noticia>> obtenerNoticias() async {
    return manejarExcepcion(
      () => _noticiaService.obtenerNoticias(),
      mensajeError: NoticiasConstantes.mensajeError,
    );
  }

  /// Crea una nueva noticia
  Future<Noticia> crearNoticia(Noticia noticia) async {
    return manejarExcepcion(() {
      validarEntidad(noticia);
      return _noticiaService.crearNoticia(noticia);
    }, mensajeError: NoticiasConstantes.errorCreated);
  }

  /// Edita una noticia existente
  Future<Noticia> editarNoticia(Noticia noticia) async {
    return manejarExcepcion(() {
      validarEntidad(noticia);
      return _noticiaService.editarNoticia(noticia);
    }, mensajeError: NoticiasConstantes.errorUpdated);
  }

  /// Elimina una noticia y sus reportes asociados
  Future<void> eliminarNoticia(String id) async {
    return manejarExcepcion(() async {
      validarId(id);
      await reporteRepo.eliminarReportesPorNoticia(id);
      await _noticiaService.eliminarNoticia(id);
    }, mensajeError: NoticiasConstantes.errorDelete);
  }

  /// Incrementa el contador de reportes de una noticia y devuelve solo los campos actualizados
  Future<Map<String, dynamic>> incrementarContadorReportes(String noticiaId, int valor) async {
    return manejarExcepcion(() {
      validarId(noticiaId);
      return _noticiaService.incrementarContadorReportes(noticiaId, valor);
    }, mensajeError: NoticiasConstantes.errorActualizarContadorReportes);
  }
}
