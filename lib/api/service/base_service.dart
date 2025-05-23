import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/core/api_config.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';
import 'package:mi_proyecto/helpers/connectivity_service.dart';
import 'package:mi_proyecto/helpers/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart' show di;

/// Clase base para servicios API que proporciona funcionalidad común
class BaseService {
  late final Dio _dio;
  final SecureStorageService _secureStorage = SecureStorageService();

  
  /// Constructor que inicializa la configuración de Dio con los parámetros base
  BaseService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.beeceptorBaseUrl,
        connectTimeout: const Duration(
          milliseconds: (AppConstantes.timeoutSeconds * 1000),
        ),
        receiveTimeout: const Duration(
          milliseconds: (AppConstantes.timeoutSeconds * 1000),
        ),
        headers: {
          'x-beeceptor-auth': ApiConfig.beeceptorApiKey,
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  static ApiException handleError(DioException e, String endpoint) {
    // Manejo de errores de timeout
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw ApiException(AppConstantes.errorTimeOut);
    }

    // Personalización de errores según el endpoint
    String errorNotFound = '';
    String errorUnauthorized = '';
    String errorBadRequest = '';
    String errorServer = '';

    if (endpoint.contains(ApiConstantes.categoriaEndpoint)) {
      errorNotFound = CategoriaConstantes.errorNocategoria;
      errorUnauthorized = CategoriaConstantes.errorUnauthorized;
      errorBadRequest = CategoriaConstantes.errorInvalidData;
      errorServer = CategoriaConstantes.errorServer;
    } else if (endpoint.contains(ApiConstantes.noticiasEndpoint)) {
      errorNotFound = NoticiasConstantes.errorNotFound;
      errorUnauthorized = NoticiasConstantes.errorUnauthorized;
      errorBadRequest = NoticiasConstantes.errorInvalidData;
      errorServer = NoticiasConstantes.errorServer;
    }else if (endpoint.contains(ApiConstantes.preferenciasEndpoint)) {
      errorNotFound = PreferenciaConstantes.errorNotFound;
      errorUnauthorized = PreferenciaConstantes.errorUnauthorized;
      errorBadRequest = PreferenciaConstantes.errorInvalidData;
      errorServer = PreferenciaConstantes.errorServer;
    } else if (endpoint.contains(ApiConstantes.reportesEndpoint)) {
      errorNotFound = ReporteConstantes.errorNotFound;
      errorUnauthorized = ReporteConstantes.errorUnauthorized;
      errorBadRequest = ReporteConstantes.errorInvalidData;
      errorServer = ReporteConstantes.errorServer;
    } else if (endpoint.contains(ApiConstantes.comentariosEndpoint)) {
      errorNotFound = ComentarioConstantes.errorNotFound;
      errorUnauthorized = ComentarioConstantes.errorUnauthorized;
      errorBadRequest = ComentarioConstantes.errorInvalidData;
      errorServer = ComentarioConstantes.errorServer;
    }
    // falta los otros endpoints
    final statusCode = e.response?.statusCode;
    
    // Aplicar código de estado al tipo de recurso
    switch (statusCode) {
      case 400:
        return ApiException(errorBadRequest, statusCode: 400);
      case 401:
        return ApiException(errorUnauthorized, statusCode: 401);
      case 403:
        // Error de autorización - Problemas con API key o IP no autorizada
        return ApiException(AppConstantes.errorAccesoDenegado, statusCode: 403);
      case 404:
        // Personalización para recurso no encontrado
        return ApiException(errorNotFound, statusCode: 404);
      case 429:
        // Límite de tasa alcanzado en Beeceptor
        return ApiException(AppConstantes.limiteAlcanzado, statusCode: 429);
      case 500:
        return ApiException(errorServer, statusCode: 500);
      case 561:
        // Error en la plantilla de respuesta de Beeceptor
        return ApiException(AppConstantes.errorServidorMock, statusCode: 561);
      case 562:
        // Necesita autorización en Beeceptor (x-beeceptor-auth)
        return ApiException(AppConstantes.errorUnauthorized, statusCode: 562);
      case 571:
      case 572:
      case 573:
      case 574:
      case 575:
      case 576:
      case 577:
      case 578:
        // Errores de conexión proxy de Beeceptor
        return ApiException(AppConstantes.errorConexionProxy, statusCode: statusCode);
      case 580:
        // Cliente desconectado (socket hang up)
        return ApiException(AppConstantes.conexionInterrumpida, statusCode: 580);
      case 581:
        // Error al recuperar archivo en Beeceptor
        return ApiException(AppConstantes.errorRecuperarRecursos, statusCode: 581);
      case 599:
        // Error crítico en Beeceptor
        return ApiException(AppConstantes.errorCriticoServidor, statusCode: 599);
      default:
        return ApiException('Error desconocido en $endpoint', statusCode: statusCode);
    }
  }

    /// Método privado que ejecuta una petición HTTP y maneja los errores de forma centralizada
  Future<T> _executeRequest<T>(
    Future<Response<dynamic>> Function() requestFn,
    String errorMessage,
  ) async {
    try {
      final connectivityService = di<ConnectivityService>();
      // Verificar la conectividad antes de realizar la solicitud HTTP 
      await connectivityService.checkConnectivity();
      
      // Proceder con la solicitud HTTP si hay conectividad
      final response = await requestFn();
      
      if (response.statusCode == 200) {
        return response.data as T;
      } else {
        throw ApiException(
          errorMessage,
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      final endpoint = e.requestOptions.path;
      debugPrint('Error en la solicitud: ${e.message}');
      throw handleError(e, endpoint);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      // Manejo de cualquier otro tipo de error
      throw ApiException('Error inesperado: ${e.toString()}');
    }
  }
  /// Método genérico para realizar solicitudes GET
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    String errorMessage = AppConstantes.errorGetDefault,
    bool requireAuthToken = false,
  }) async {
    final options = await _getRequestOptions(requireAuthToken: requireAuthToken);
    return _executeRequest<T>(
      () => _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      ),
      errorMessage,
    );
  }
  /// Método genérico para realizar solicitudes POST
  Future<dynamic> post(
    String endpoint, {
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    String errorMessage = AppConstantes.errorCreateDefault,
    bool requireAuthToken = false,
  }) async {
    final options = await _getRequestOptions(requireAuthToken: requireAuthToken);
    return _executeRequest<dynamic>(
      () => _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      errorMessage,
    );
  }
  /// Método genérico para realizar solicitudes PUT
  Future<dynamic> put(
    String endpoint, {
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    String errorMessage = AppConstantes.errorUpdateDefault,
    bool requireAuthToken = false,
  }) async {
    final options = await _getRequestOptions(requireAuthToken: requireAuthToken);
    return _executeRequest<dynamic>(
      () => _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      errorMessage,
    );
  }

  /// Método genérico para realizar solicitudes DELETE
  Future<dynamic> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    String errorMessage = AppConstantes.errorDeleteDefault,
    bool requireAuthToken = false,
  }) async {
    final options = await _getRequestOptions(requireAuthToken: requireAuthToken);
    return _executeRequest<dynamic>(
      () => _dio.delete(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      ),
      errorMessage,
    );
  }

  /// Obtiene opciones de solicitud con token de autenticación si es requerido
  Future<Options> _getRequestOptions({bool requireAuthToken = false}) async {
    final options = Options();
    
    if (requireAuthToken) {
      final jwt = await _secureStorage.getJwt();
      if (jwt != null && jwt.isNotEmpty) {
        options.headers = {
          ...(options.headers ?? {}),
          'X-Auth-Token': jwt,
        };
      } else {
        throw ApiException(
          AppConstantes.tokenNoEncontrado,
          statusCode: 401,
        );
      }
    }
    
    return options;
  }
}
