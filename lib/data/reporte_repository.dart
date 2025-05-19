import 'package:mi_proyecto/api/service/reporte_service.dart';
import 'package:mi_proyecto/data/base_repository.dart';
import 'package:mi_proyecto/domain/reporte.dart';

class ReporteRepository extends BaseRepository {
  final ReporteService _reporteService = ReporteService();

  // Obtener todos los reportes
  Future<List<Reporte>> obtenerReportes() async {
    return executeWithTryCatch(
      () => _reporteService.getReportes(),
      'obtener reportes',
    );
  }

  // Crear un nuevo reporte
  Future<Reporte?> crearReporte({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    return executeWithTryCatch(
      () => _reporteService.crearReporte(
        noticiaId: noticiaId,
        motivo: motivo,
      ),
      'crear reporte',
    );
  }

  // Obtener reportes por id de noticia
  Future<List<Reporte>> obtenerReportesPorNoticia(String noticiaId) async {
    return executeWithTryCatch(
      () async {
        final reportes = await _reporteService.getReportesPorNoticia(noticiaId);
        return validateListNotEmpty(
          reportes,
          'No se encontraron reportes para esta noticia',
        );
      },
      'obtener reportes por noticia',
    );
  }

  // Eliminar un reporte
  Future<void> eliminarReporte(String reporteId) async {
    return executeWithTryCatch(
      () => _reporteService.eliminarReporte(reporteId),
      'eliminar reporte',
    );
  }
}