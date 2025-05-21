import 'package:flutter/foundation.dart';
import 'package:mi_proyecto/api/service/comentarios_service.dart';
import 'package:mi_proyecto/data/base_repository.dart';
import 'package:mi_proyecto/domain/comentario.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

class ComentarioRepository extends BaseRepository {
  final ComentariosService _service = ComentariosService();

  /// Obtiene los comentarios asociados a una noticia específica
  Future<List<Comentario>> obtenerComentariosPorNoticia(String noticiaId) async {
    try {
      logOperationStart('obtener', 'comentarios', noticiaId);
      final comentarios = await _service.obtenerComentariosPorNoticia(noticiaId);
      logOperationSuccess('obtenidos', 'comentarios', noticiaId);
      
      // Verificar si la lista está vacía (sin lanzar error)
      return checkListNotEmpty(
        comentarios, 
        'comentarios',
        lanzarError: false,
        valorPorDefecto: <Comentario>[],
      );
    } catch (e) {
      await handleError(e, 'al obtener', 'comentarios');
      // Este código no se ejecutará debido a que handleError lanza una excepción,
      // pero el compilador lo requiere
      //throw ApiException('Error inesperado al obtener comentarios.');
    }
  }

  /// Agrega un nuevo comentario a una noticia
  Future<void> agregarComentario(
    String noticiaId,
    String texto,
    String autor,
    String fecha,
  ) async {
    try {
      checkFieldNotEmpty(texto, 'texto del comentario');
      
      logOperationStart('agregar', 'comentario', noticiaId);
      await _service.agregarComentario(
        noticiaId,
        texto,
        autor,
        fecha,
      );
      logOperationSuccess('agregado', 'comentario', noticiaId);
    } catch (e) {
      await handleError(e, 'al agregar', 'comentario');
    }
  }

  /// Obtiene el número total de comentarios para una noticia específica
  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    try {
      logOperationStart('contar', 'comentarios', noticiaId);
      final count = await _service.obtenerNumeroComentarios(noticiaId);
      logOperationSuccess('contados', 'comentarios', noticiaId);
      return count;
    } catch (e) {
      // Este caso especial devuelve 0 en lugar de propagar el error
      debugPrint('Error al obtener número de comentarios: $e');
      return 0;
    }
  }

  /// Añade una reacción (like o dislike) a un comentario específico
  Future<void> reaccionarComentario({
    required String comentarioId,
    required String tipoReaccion,
  }) async {
    try {
      checkIdNotEmpty(comentarioId, 'comentario');
      checkFieldNotEmpty(tipoReaccion, 'tipo de reacción');
      
      logOperationStart('reaccionar a', 'comentario', comentarioId);
      await _service.reaccionarComentario(
        comentarioId: comentarioId,
        tipoReaccion: tipoReaccion,
      );
      logOperationSuccess('reaccionado a', 'comentario', comentarioId);
    } catch (e) {
      await handleError(e, 'al reaccionar a', 'comentario');
    }
  }

  /// Agrega un subcomentario a un comentario existente
  Future<Map<String, dynamic>> agregarSubcomentario({
    required String comentarioId,
    required String texto,
    required String autor,
  }) async {
    // Verificación previa para mensaje personalizado
    if (texto.isEmpty) {
      return {
        'success': false,
        'message': 'El texto del subcomentario no puede estar vacío.'
      };
    }

    try {
      checkIdNotEmpty(comentarioId, 'comentario');
      
      logOperationStart('agregar', 'subcomentario', comentarioId);
      final resultado = await _service.agregarSubcomentario(
        comentarioId: comentarioId,
        texto: texto,
        autor: autor,
      );
      logOperationSuccess('agregado', 'subcomentario', comentarioId);
      
      return resultado;
    } catch (e) {
      // Mantenemos el formato de respuesta consistente en caso de error
      debugPrint('Error inesperado al agregar subcomentario: $e');
      return {
        'success': false,
        'message': 'Error inesperado al agregar subcomentario: ${e.toString()}'
      };
    }
  }
}