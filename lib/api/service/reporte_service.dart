import 'dart:async';
import 'package:mi_proyecto/api/service/base_service.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/domain/reporte.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

/// Servicio para gestionar los reportes
class ReporteService extends BaseService {
  // Utilizamos el constructor del BaseService
  ReporteService({String? authToken}) : super();

  /// Verifica si una noticia existe
  Future<bool> verificarNoticiaExiste(String noticiaId) async {
    try {
      // Usamos el método get heredado de BaseService
      await get<dynamic>(
        '${ApiConstantes.noticiasEndpoint}/$noticiaId',
        errorMessage: 'Error al verificar la noticia',
      );
      return true; // Si no hay excepción, la noticia existe
    } catch (e) {
      // Si hay una ApiException con código 404, la noticia no existe
      if (e is ApiException && e.statusCode == 404) {
        return false;
      }
      // Para cualquier otro error, lo propagamos
      rethrow;
    }
  }

  /// Envía un reporte
  Future<void> enviarReporte(Reporte reporte) async {
    try {
      // Usando el método generado por dart_mappable
      final Map<String, dynamic> reporteData = reporte.toMap();
      
      // Usamos el método post heredado de BaseService
      await post(
        ApiConstantes.reportesEndpoint,
        data: reporteData,
        errorMessage: ReporteConstantes.errorCrearReporte,
        // Si se requiere autenticación para reportar, añadir: requireAuthToken: true
      );
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(ReporteConstantes.errorCrearReporte);
    }
  }

  /// Obtiene todos los reportes
  Future<List<Reporte>> obtenerReportes() async {
    try {
      // Usamos el método get heredado de BaseService
      final data = await get<List<dynamic>>(
        ApiConstantes.reportesEndpoint,
        errorMessage: ReporteConstantes.errorObtenerReportes,
        // Si se requiere autenticación para ver reportes, añadir: requireAuthToken: true
      );
      
      // Convertimos los datos a objetos Reporte
      return data.map((json) => ReporteMapper.fromMap(json)).toList();
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(ReporteConstantes.errorObtenerReportes);
    }
  }
  
  /// Obtiene estadísticas de reportes para una noticia específica
  Future<Map<MotivoReporte, int>> obtenerEstadisticasReporte(String noticiaId) async {
    try {
      // Usamos el método get heredado de BaseService
      final data = await get<Map<String, dynamic>>(
        '${ApiConstantes.reportesEndpoint}/estadisticas/$noticiaId',
        errorMessage: 'Error al obtener estadísticas de reportes',
        // Si se requiere autenticación para ver estadísticas, añadir: requireAuthToken: true
      );
      
      final estadisticas = <MotivoReporte, int>{};
      
      // Inicializar con valores predeterminados
      for (final motivo in MotivoReporte.values) {
        estadisticas[motivo] = 0;
      }
      
      // Si hay datos en la respuesta, actualizamos los contadores
      if (data.containsKey('estadisticas')) {
        final stats = data['estadisticas'] as Map<String, dynamic>;
        
        // Parseamos cada valor en el mapa
        if (stats.containsKey('noticiaInapropiada')) {
          estadisticas[MotivoReporte.noticiaInapropiada] = stats['noticiaInapropiada'] as int;
        }
        
        if (stats.containsKey('informacionFalsa')) {
          estadisticas[MotivoReporte.informacionFalsa] = stats['informacionFalsa'] as int;
        }
        
        if (stats.containsKey('otro')) {
          estadisticas[MotivoReporte.otro] = stats['otro'] as int;
        }
      }
      
      return estadisticas;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al obtener estadísticas de reportes');
    }
  }
}
