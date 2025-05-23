import 'package:mi_proyecto/api/service/reporte_service.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/data/base_repository.dart';
import 'package:mi_proyecto/domain/reporte.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

class ReporteRepository extends CacheableRepository<Reporte> {
  final ReporteService _reporteService = ReporteService();

  @override
  void validarEntidad(Reporte reporte) {
    validarNoVacio(reporte.noticiaId, 'ID de la noticia');
    // Validaciones adicionales si es necesario
  }

  @override
  Future<List<Reporte>> cargarDatos() async {
    return await _reporteService.obtenerReportes();
  }

  /// Envía un reporte de una noticia
  Future<bool> enviarReporte({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    return manejarExcepcion(() async {
      // Verificar que la noticia exista
      final noticiaExiste = await _reporteService.verificarNoticiaExiste(noticiaId);
      
      if (!noticiaExiste) {
        throw ApiException(ReporteConstantes.noticiaNoExiste);
      }
      
      // Crear el objeto Reporte
      final reporte = Reporte(
        noticiaId: noticiaId,
        fecha: DateTime.now().toIso8601String(),
        motivo: motivo,
      );
      
      // Enviar el reporte
      await _reporteService.enviarReporte(reporte);
      
      // Invalidar caché si la operación fue exitosa
      invalidarCache();
      
      return true;
    }, mensajeError: 'Error al enviar reporte');
  }

  /// Obtiene todos los reportes
  Future<List<Reporte>> obtenerReportes() async {
    return await obtenerDatos();
  }
  
  /// Obtiene estadísticas de reportes por motivo
  Future<Map<MotivoReporte, int>> obtenerEstadisticasReportes() async {
    return manejarExcepcion(() async {
      final reportes = await obtenerReportes();
      final estadisticas = <MotivoReporte, int>{};
      
      // Inicializar contadores
      for (final motivo in MotivoReporte.values) {
        estadisticas[motivo] = 0;
      }
      
      // Contar reportes por motivo
      for (final reporte in reportes) {
        estadisticas[reporte.motivo] = (estadisticas[reporte.motivo] ?? 0) + 1;
      }
      
      return estadisticas;
    }, mensajeError: 'Error al obtener estadísticas');
  }
  
  /// Obtiene estadísticas de reportes de una noticia específica
  Future<Map<MotivoReporte, int>> obtenerEstadisticasReportesPorNoticia(String noticiaId) async {
    return manejarExcepcion(() async {
      validarNoVacio(noticiaId, 'ID de la noticia');
      
      final reportes = await obtenerReportes();
      final estadisticas = <MotivoReporte, int>{};
      
      // Inicializar contadores
      for (final motivo in MotivoReporte.values) {
        estadisticas[motivo] = 0;
      }
      
      // Contar reportes por motivo para esta noticia
      for (final reporte in reportes) {
        if (reporte.noticiaId == noticiaId) {
          estadisticas[reporte.motivo] = (estadisticas[reporte.motivo] ?? 0) + 1;
        }
      }
      
      return estadisticas;
    }, mensajeError: 'Error al obtener estadísticas por noticia');
  }
  
  /// Verifica si el usuario actual ha reportado una noticia con un motivo específico
  /// Ahora siempre devuelve false para permitir reportes múltiples
  Future<bool> verificarReporteUsuario({
    required String noticiaId, 
    required MotivoReporte motivo
  }) async {
    // Siempre retornar false para permitir que el usuario reporte múltiples veces
    return false;
  }
}
