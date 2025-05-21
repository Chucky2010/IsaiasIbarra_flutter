import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kgaona/api/service/base_service.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/core/api_config.dart';
import 'package:kgaona/domain/comentario.dart';
import 'package:kgaona/exceptions/api_exception.dart';

class ComentarioService extends BaseService {
  /// Obtiene todos los comentarios de una noticia específica
  Future<List<Comentario>> obtenerComentariosPorNoticia(
    String noticiaId,
  ) async {
    final endpoint = ApiConfig.comentariosEndpoint;
    final List<dynamic> comentariosJson = await get<List<dynamic>>(
      endpoint,
      errorMessage: ConstantesComentarios.mensajeError,
    );

    // Filtrar solo los comentarios para la noticia específica
    return comentariosJson
        .where((json) => json['noticiaId'] == noticiaId)
        .map<Comentario>(
          (json) => ComentarioMapper.fromMap(json as Map<String, dynamic>),
        )
        .toList();
  }

  /// Agrega un nuevo comentario a una noticia
  Future<void> agregarComentario(Comentario comentario) async {
    await post(
      ApiConfig.comentariosEndpoint,
      data: comentario.toMap(),
      errorMessage: 'Error al agregar el comentario',
    );
  }

  /// Calcula el número de comentarios para una noticia específica
  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    // Obtenemos todos los comentarios de la noticia
    final comentarios = await obtenerComentariosPorNoticia(noticiaId);

    int contador = comentarios.length;

    // Sumamos también los subcomentarios
    for (var comentario in comentarios) {
      if (comentario.subcomentarios != null) {
        contador += comentario.subcomentarios!.length;
      }
    }

    return contador;
  }

  /// Registra una reacción (like o dislike) a un comentario o subcomentario
  Future<void> reaccionarComentario({
    required String comentarioId,
    required String tipoReaccion,
  }) async {
    try {
      // Obtenemos todos los comentarios
      final data = await get('/comentarios', requireAuthToken: false);

      if (data is! List) {
        throw ApiException('Formato de respuesta inválido');
      }

      final List<dynamic> comentarios = data;

      // Primero, buscamos si es un comentario principal
      final comentarioIndex = comentarios.indexWhere(
        (c) => c['id'] == comentarioId,
      );

      // Si lo encontramos como comentario principal
      if (comentarioIndex != -1) {
        Map<String, dynamic> comentarioActualizado = Map<String, dynamic>.from(
          comentarios[comentarioIndex],
        );

        int currentLikes = comentarioActualizado['likes'] ?? 0;
        int currentDislikes = comentarioActualizado['dislikes'] ?? 0;

        // Actualizar contadores
        if (tipoReaccion == 'like') {
          currentLikes += 1;
        } else if (tipoReaccion == 'dislike') {
          currentDislikes += 1;
        }

        // Enviar actualización
        await put(
          '/comentarios/$comentarioId',
          data: {
            'noticiaId': comentarioActualizado['noticiaId'],
            'texto': comentarioActualizado['texto'],
            'fecha': comentarioActualizado['fecha'],
            'autor': comentarioActualizado['autor'],
            'likes': currentLikes,
            'dislikes': currentDislikes,
            'subcomentarios': comentarioActualizado['subcomentarios'] ?? [],
            'isSubComentario':
                comentarioActualizado['isSubComentario'] ?? false,
          },
          requireAuthToken: true,
        );

        // Respuesta exitosa, retornamos
        return;
      }      // Recorrer todos los comentarios principales
      for (int i = 0; i < comentarios.length; i++) {
        final comentarioPrincipal = comentarios[i];

        // Verificar si tiene subcomentarios
        if (comentarioPrincipal['subcomentarios'] != null &&
            comentarioPrincipal['subcomentarios'] is List &&
            (comentarioPrincipal['subcomentarios'] as List).isNotEmpty) {
          final List<dynamic> subcomentarios =
              comentarioPrincipal['subcomentarios'];

          // Buscar en los subcomentarios si alguno coincide con el ID
          for (int j = 0; j < subcomentarios.length; j++) {
            final subcomentario = subcomentarios[j];            // Si encontramos el ID en el subcomentario
            if (subcomentario['id'] == comentarioId ||
                subcomentario['idSubComentario'] == comentarioId) {
              // Crear una copia del subcomentario para actualizarlo
              Map<String, dynamic> subcomentarioActualizado =
                  Map<String, dynamic>.from(subcomentario);

              // Actualizar los contadores según el tipo de reacción
              int currentLikes = subcomentarioActualizado['likes'] ?? 0;
              int currentDislikes = subcomentarioActualizado['dislikes'] ?? 0;
              
              // Incrementar el contador adecuado
              if (tipoReaccion == 'like') {
                currentLikes += 1;
              } else if (tipoReaccion == 'dislike') {
                currentDislikes += 1;
              }
              
              // Asignar los valores actualizados
              subcomentarioActualizado['likes'] = currentLikes;
              subcomentarioActualizado['dislikes'] = currentDislikes;
              // Actualizar la lista de subcomentarios
              subcomentarios[j] = subcomentarioActualizado;
              // Actualizar el comentario principal con la nueva lista de subcomentarios
              await put(
                '/comentarios/${comentarioPrincipal['id']}',
                data: {
                  'noticiaId': comentarioPrincipal['noticiaId'],
                  'texto': comentarioPrincipal['texto'],
                  'fecha': comentarioPrincipal['fecha'],
                  'autor': comentarioPrincipal['autor'],
                  'likes': comentarioPrincipal['likes'] ?? 0,
                  'dislikes': comentarioPrincipal['dislikes'] ?? 0,
                  'subcomentarios': subcomentarios,
                  'isSubComentario':
                      comentarioPrincipal['isSubComentario'] ?? false,
                },
                requireAuthToken: true,
              );

              return;
            }
          }
        }
      }

      throw ApiException(ConstantesApi.errorServer, statusCode: 404);
    } on DioException catch (e) {
      debugPrint('❌ DioException en reaccionarComentario: ${e.toString()}');
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en reaccionarComentario: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Agrega un subcomentario a un comentario existente
  /// Agrega un subcomentario a un comentario existente
  /// Los subcomentarios no pueden tener a su vez subcomentarios
  Future<Map<String, dynamic>> agregarSubcomentario({
    required String comentarioId, // ID del comentario principal
    required String texto,
    required String autor,
  }) async {
    try {
      final subcomentarioId =
          'sub_${DateTime.now().millisecondsSinceEpoch}_${texto.hashCode}'; // Primero, obtener el comentario al que queremos añadir un subcomentario
      final data = await get(
        '/comentarios/$comentarioId',
        requireAuthToken: false,
      );

      if (data is! Map<String, dynamic>) {
        return {'success': false, 'message': 'Formato de respuesta inválido'};
      }

      final comentarioData = data;

      // Verificar si estamos intentando añadir un subcomentario a otro subcomentario
      if (comentarioData['isSubComentario'] == true) {
        // Si no tiene campo de subcomentarios, es probable que estemos intentando
        // añadir un subcomentario a otro subcomentario, lo cual no está permitido
        return {
          'success': false,
          'message':
              'No se pueden añadir subcomentarios a otros subcomentarios',
        };
      }

      // Verificar si ya existe un subcomentario (opcional, puedes permitir múltiples subcomentarios)
      if ((comentarioData['subcomentarios'] as List).isNotEmpty) {
        // Si quieres permitir varios subcomentarios, comenta o elimina esta verificación
        // return {
        //   'success': false,
        //   'message': 'Este comentario ya contiene un subcomentario, no es posible agregar otro'
        // };
      }      // Crear el nuevo subcomentario explícitamente SIN campo de subcomentarios
      final nuevoSubcomentario = Comentario(
        id: subcomentarioId, // Asignamos un ID único para este subcomentario
        noticiaId: comentarioData['noticiaId'],
        texto: texto,
        fecha: DateTime.now().toIso8601String(),
        autor: autor,
        likes: 0,
        dislikes: 0,
        subcomentarios: [],
        isSubComentario: true,
        idSubComentario: comentarioId, // Referencia al comentario padre
      );

      // Obtener la lista actual de subcomentarios o inicializarla
      final List<dynamic> subcomentariosActuales =
          comentarioData['subcomentarios'] as List<dynamic>? ?? [];

      // Añadir el nuevo subcomentario a la lista existente
      final subcomentariosActualizados = [
        ...subcomentariosActuales,
        nuevoSubcomentario.toMap(),
      ]; // Actualizar el comentario con todos sus subcomentarios
      await put(
        '/comentarios/$comentarioId',
        data: {
          'noticiaId': comentarioData['noticiaId'],
          'texto': comentarioData['texto'],
          'fecha': comentarioData['fecha'],
          'autor': comentarioData['autor'],
          'likes': comentarioData['likes'] ?? 0,
          'dislikes': comentarioData['dislikes'] ?? 0,
          'subcomentarios': subcomentariosActualizados,
          'isSubComentario':
              false, // Asegurarse de que el comentario principal no sea un subcomentario
        },
        requireAuthToken: true,
      );

      return {
        'success': true,
        'message': 'Subcomentario agregado correctamente',
      };
    } on DioException catch (e) {
      debugPrint('❌ DioException en agregarSubcomentario: ${e.toString()}');
      String mensaje;
      try {
        mensaje = 'Error desconocido';
      } on ApiException catch (apiError) {
        mensaje = apiError.message;
      }

      return {'success': false, 'message': mensaje};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: ${e.toString()}'};
    }
  }
}
