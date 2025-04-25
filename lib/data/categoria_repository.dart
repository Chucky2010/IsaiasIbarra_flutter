import 'package:dio/dio.dart';
import 'package:mi_proyecto/constants.dart';
import 'package:mi_proyecto/domain/categoria.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

class CategoriaRepository {
  final Dio _dio;
   
   CategoriaRepository()
   : _dio= Dio(
    BaseOptions(
    connectTimeout: const Duration(milliseconds: Constants.timeoutSeconds * 1000),//tiempo espera maximo para conexion
    receiveTimeout: const Duration(milliseconds: Constants.timeoutSeconds * 1000),//tiempo espera maximo para recibir datos
  ));


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
      if (e.type == DioExceptionType.connectionTimeout
      || e.type == DioExceptionType.receiveTimeout) {
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

      if (response.statusCode != 201) {
        throw ApiException(
          'Error al crear la categoría',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout
      || e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(Constants.errorTimeout);
      }
      throw ApiException('Error al conectar con la API de categorías: $e');
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

      if (response.statusCode != 200) {
        throw ApiException(
          'Error al editar la categoría',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout
      || e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(Constants.errorTimeout);
      }
      throw ApiException('Error al conectar con la API de categorías: $e');
    }
  }

  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    try {
      final url = '${Constants.urlCategorias}/$id';
      final response = await _dio.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          'Error al eliminar la categoría',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout
      || e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(Constants.errorTimeout);
      }
      throw ApiException('Error al conectar con la API de categorías: $e');
    }
  }
}
