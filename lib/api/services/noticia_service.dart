import 'package:mi_proyecto/domain/noticia.dart';
import 'package:dio/dio.dart';
import 'package:mi_proyecto/constants.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

class NoticiaService {
  final Dio _dio;

  NoticiaService()
    : _dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(
            milliseconds: Constants.timeoutSeconds * 1000,
          ), //tiempo espera maximo para conexion
          receiveTimeout: const Duration(
            milliseconds: Constants.timeoutSeconds * 1000,
          ), //tiempo espera maximo para recibir datos
        ),
      ); // URL base de la API

  Future<List<Noticia>> fetchNoticiasFromApi(
    int pageNumber,
    int pageSize,
  ) async {
    try {
      final response = await _dio.get(Constants.urlNoticias);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        if (data.isEmpty) {
          return []; // Si no hay datos, devuelve una lista vacía
        }
        final noticias = data.map((json) => Noticia.fromJson(json)).toList();

        return noticias;
      } else if (response.statusCode != null &&
          response.statusCode! >= 400 &&
          response.statusCode! < 500) {
        // Manejo específico para errores 4xx
        throw ApiException(
          'Error al obtener las noticias',
          statusCode: response.statusCode,
        );
      } else {
        throw ApiException('No se pudo obtener las noticias');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(
          Constants.errorTimeout, // Mensaje de timeout
          statusCode: e.response?.statusCode,
        );
      }
      throw ApiException(
        'Error al conectar con la API de noticias: $e',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  Future<void> createNoticia(Noticia noticia) async {
    try {
      final response = await _dio.post(
        Constants.urlNoticias,
        data: {
          "titulo": noticia.titulo,
          "descripcion": noticia.descripcion,
          "fuente": noticia.fuente,
          "publicadaEl": noticia.publicadaEl.toIso8601String(),
          "urlImagen": noticia.imageUrl,
          "categoriaId": noticia.categoriaId,
        },
      );

      if (response.statusCode != 201) {
        throw ApiException(
          'Error al crear la noticia',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(Constants.errorTimeout);
      }
      throw ApiException('Error al conectar con la API de noticias: $e');
    }
  }

  Future<void> updateNoticia(Noticia noticia) async {
    try {
      final response = await _dio.put(
        '${Constants.urlNoticias}/${noticia.id}', // URL con el ID de la noticia
        data: {
          "titulo": noticia.titulo,
          "descripcion": noticia.descripcion,
          "fuente": noticia.fuente,
          "publicadaEl": noticia.publicadaEl.toIso8601String(),
          "urlImagen": noticia.imageUrl,
          "categoriaId": noticia.categoriaId,
        },
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'Error al aditar la noticia',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(Constants.errorTimeout);
      }
      throw ApiException('Error al conectar con la API de noticias: $e');
    }
  }

  Future<void> deleteNoticia(String id) async {
    try {
      final response = await _dio.delete(
        '${Constants.urlNoticias}/$id',
      ); // URL con el ID de la noticia

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          'Error al eliminar la noticia',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(Constants.errorTimeout);
      }
      throw ApiException('Error al conectar con la API de noticias: $e');
    }
  }
}
