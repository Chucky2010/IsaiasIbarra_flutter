import 'package:flutter/foundation.dart';
import 'package:mi_proyecto/api/service/comentarios_service.dart';
import 'package:mi_proyecto/data/base_repository.dart';
import 'package:mi_proyecto/domain/comentario.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

class ComentarioRepository extends BaseRepository {
  final ComentariosService _service = ComentariosService();
  /// Obtiene los comentarios asociados a una noticia específica
  Future<List<Comentario>> obtenerComentariosPorNoticia(String noticiaId) async {
    return executeWithTryCatch(
      () async {
        final comentarios = await _service.obtenerComentariosPorNoticia(noticiaId);
        return validateListNotEmpty(
          comentarios,
          'No hay comentarios para esta noticia',
          throwIfEmpty: false, // No lanzar error si está vacío, solo devolver lista vacía
        );
      },
      'obtener comentarios',
    );
  }
  /// Agrega un nuevo comentario a una noticia
  Future<void> agregarComentario(
    String noticiaId,
    String texto,
    String autor,
    String fecha,
  ) async {
    if (texto.isEmpty) {
      throw ApiException('El texto del comentario no puede estar vacío.');
    }
    
    return executeWithTryCatch(
      () => _service.agregarComentario(
        noticiaId,
        texto,
        autor,
        fecha,
      ),
      'agregar comentario',
    );
  }
  /// Obtiene el número total de comentarios para una noticia específica
  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    try {
      // Usamos try-catch directo porque queremos devolver 0 en caso de error
      // en lugar de propagar la excepción
      return await executeWithTryCatch(
        () => _service.obtenerNumeroComentarios(noticiaId),
        'obtener número de comentarios',
      );
    } catch (e) {
      debugPrint('Error al obtener número de comentarios: $e');
      return 0; // En caso de error, retornamos 0 como valor seguro
    }
  }
  /// Añade una reacción (like o dislike) a un comentario específico
  Future<void> reaccionarComentario({
    required String comentarioId,
    required String tipoReaccion,
  }) async {
    return executeWithTryCatch(
      () => _service.reaccionarComentario(
        comentarioId: comentarioId,
        tipoReaccion: tipoReaccion,
      ),
      'reaccionar al comentario',
    );
  }
  /// Agrega un subcomentario a un comentario existente
  Future<Map<String, dynamic>> agregarSubcomentario({
    required String comentarioId,
    required String texto,
    required String autor,
  }) async {
    if (texto.isEmpty) {
      return {
        'success': false,
        'message': 'El texto del subcomentario no puede estar vacío.'
      };
    }

    try {
      return await executeWithTryCatch(
        () => _service.agregarSubcomentario(
          comentarioId: comentarioId,
          texto: texto,
          autor: autor,
        ),
        'agregar subcomentario',
      );
    } catch (e) {
      debugPrint('Error inesperado al agregar subcomentario: $e');
      return {
        'success': false,
        'message': 'Error inesperado al agregar subcomentario: ${e.toString()}'
      };
    }
  }
}