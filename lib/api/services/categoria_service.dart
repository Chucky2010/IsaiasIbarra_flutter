import 'package:dio/dio.dart';
import 'package:mi_proyecto/constants.dart';
import 'package:mi_proyecto/domain/categoria.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

class CategoriaService {
  final Dio _dio;

  CategoriaService()
    : _dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(
            milliseconds: Constants.timeoutSeconds * 1000,
          ), //tiempo espera maximo para conexion
          receiveTimeout: const Duration(
            milliseconds: Constants.timeoutSeconds * 1000,
          ), //tiempo espera maximo para recibir datos
        ),
      );

  /// Obtiene todas las categorías desde la API
  Future<List<Categoria>> getCategorias() async {
    try {
      final response = await _dio.get(Constants.urlCategorias);

      if (response.statusCode == 200) {
        final List<dynamic> categoriasJson = response.data;
        return categoriasJson.map((json) => Categoria.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Error al obtener las categorías',
          statusCode: response.statusCode,
        );
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
        'Error al conectar con la API de categorías: $e',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Crea una nueva categoría en la API
  Future<void> crearCategoria(Map<String, dynamic> categoria) async {
    try {
      final response = await _dio.post(
        Constants.urlCategorias,
        data: categoria,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Categoría creada exitosamente
        return;
      }
      else if (response.statusCode == 400) {
        throw ApiException(Constants.mensajeError, statusCode: 400);
      } else if (response.statusCode == 401) {
        throw ApiException(Constants.errorUnauthorized, statusCode: 401);
      } else if (response.statusCode == 404) {
        throw ApiException(Constants.errorNotFound, statusCode: 404);
      } else if (response.statusCode == 500) {
        throw ApiException(Constants.errorServer, statusCode: 500);
      } else {
        throw ApiException(
          'Error desconocido al crear la categoria',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(Constants.errorTimeout);
      }
      throw ApiException('Error al conectar con la API de categorias: $e');
    }
  }

  /// Edita una categoría existente en la API
  Future<void> editarCategoria(
    String id,
    Map<String, dynamic> categoria,
  ) async {
    try {
      final url = '${Constants.urlCategorias}/$id';
      final response = await _dio.put(url, data: categoria);

      if (response.statusCode == 400) {
        throw ApiException(Constants.mensajeError, statusCode: 400);
      } else if (response.statusCode == 401) {
        throw ApiException(Constants.errorUnauthorized, statusCode: 401);
      } else if (response.statusCode == 404) {
        throw ApiException(Constants.errorNotFound, statusCode: 404);
      } else if (response.statusCode == 500) {
        throw ApiException(Constants.errorServer, statusCode: 500);
      } else if (response.statusCode != 200) {
        throw ApiException(
          'Error desconocido al crear la noticia',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(Constants.errorTimeout);
      }
      throw ApiException('Error al conectar con la API de categorias: $e');
    }
  }

  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    try {
      final url = '${Constants.urlCategorias}/$id';
      final response = await _dio.delete(url);

      if (response.statusCode == 400) {
        throw ApiException(Constants.mensajeError, statusCode: 400);
      } else if (response.statusCode == 401) {
        throw ApiException(Constants.errorUnauthorized, statusCode: 401);
      } else if (response.statusCode == 404) {
        throw ApiException(Constants.errorNotFound, statusCode: 404);
      } else if (response.statusCode == 500) {
        throw ApiException(Constants.errorServer, statusCode: 500);
      } else if (response.statusCode != 200) {
        throw ApiException(
          'Error desconocido al crear la noticia',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(Constants.errorTimeout);
      }
      throw ApiException('Error al conectar con la API de categorias: $e');
    }
  }
}
