import 'package:flutter/foundation.dart';
import 'package:mi_proyecto/api/service/reporte_service.dart';
import 'package:mi_proyecto/data/base_repository.dart';
import 'package:mi_proyecto/domain/reporte.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

class ReporteRepository extends BaseRepository {
  final ReporteService _reporteService = ReporteService();

  // Obtener todos los reportes
  Future<List<Reporte>> obtenerReportes() async {
    try {
      logOperationStart('obtener', 'reportes');
      final reportes = await _reporteService.getReportes();
      logOperationSuccess('obtenidos', 'reportes');
      
      return checkListNotEmpty(
        reportes,
        'reportes',
        lanzarError: false,
        valorPorDefecto: <Reporte>[],
      );
    } catch (e) {
      await handleError(e, 'al obtener', 'reportes');
      // Este código no se ejecutará debido a que handleError lanza una excepción,
      // pero es necesario para satisfacer al compilador
      //throw ApiException('Error inesperado al obtener reportes');
    }
  }

  // Crear un nuevo reporte
  Future<Reporte?> crearReporte({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    try {
      checkIdNotEmpty(noticiaId, 'noticia');
      
      logOperationStart('crear', 'reporte', noticiaId);
      final reporte = await _reporteService.crearReporte(
        noticiaId: noticiaId,
        motivo: motivo,
      );
      logOperationSuccess('creado', 'reporte', noticiaId);
      
      return reporte;
    } catch (e) {
      await handleError(e, 'al crear', 'reporte');
      // Este código no se ejecutará
      //throw ApiException('Error inesperado al crear reporte');
    }
  }

  // Obtener reportes por id de noticia
  Future<List<Reporte>> obtenerReportesPorNoticia(String noticiaId) async {
    try {
      checkIdNotEmpty(noticiaId, 'noticia');
      
      logOperationStart('obtener', 'reportes por noticia', noticiaId);
      final reportes = await _reporteService.getReportesPorNoticia(noticiaId);
      logOperationSuccess('obtenidos', 'reportes por noticia', noticiaId);
      
      return checkListNotEmpty(
        reportes,
        'reportes',
        lanzarError: false,
        valorPorDefecto: <Reporte>[],
      );
    } catch (e) {
      await handleError(e, 'al obtener', 'reportes por noticia');
      // Este código no se ejecutará
      //throw ApiException('Error inesperado al obtener reportes por noticia');
    }
  }

  // Eliminar un reporte
  Future<void> eliminarReporte(String reporteId) async {
    try {
      checkIdNotEmpty(reporteId, 'reporte');
      
      logOperationStart('eliminar', 'reporte', reporteId);
      await _reporteService.eliminarReporte(reporteId);
      logOperationSuccess('eliminado', 'reporte', reporteId);
    } catch (e) {
      await handleError(e, 'al eliminar', 'reporte');
    }
  }
  
  // Obtener el conteo de reportes por noticia
  Future<Map<MotivoReporte, int>> obtenerConteoReportesPorNoticia(String noticiaId) async {
    try {
      checkIdNotEmpty(noticiaId, 'noticia');
      
      logOperationStart('contar', 'reportes por noticia', noticiaId);
      final reportes = await obtenerReportesPorNoticia(noticiaId);
      
      final Map<MotivoReporte, int> conteo = {
        MotivoReporte.noticiaInapropiada: 0,
        MotivoReporte.informacionFalsa: 0,
        MotivoReporte.otro: 0,
      };
      
      for (var reporte in reportes) {
        conteo[reporte.motivo] = (conteo[reporte.motivo] ?? 0) + 1;
      }
      
      logOperationSuccess('contados', 'reportes por noticia', noticiaId);
      return conteo;
    } catch (e) {
      await handleError(e, 'al contar', 'reportes por noticia');
      // Este código no se ejecutará
      //throw ApiException('Error inesperado al contar reportes por noticia');
    }
  }
  
  // Obtener el total de reportes por noticia
  Future<int> obtenerTotalReportesPorNoticia(String noticiaId) async {
    try {
      final Map<MotivoReporte, int> conteo = await obtenerConteoReportesPorNoticia(noticiaId);
      return conteo.values.fold<int>(0, (int prev, int count) => prev + count);
    } catch (e) {
      debugPrint('Error al obtener total de reportes: $e');
      // En caso de error, devolver 0 para no afectar la UI
      return 0;
    }
  }
}