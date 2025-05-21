import 'package:dio/dio.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/core/api_config.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:kgaona/helpers/connectivity_service.dart';
import 'package:kgaona/helpers/secure_storage_service.dart';
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
          milliseconds: (ConstantesApi.timeoutSeconds * 1000),
        ),
        receiveTimeout: const Duration(
          milliseconds: (ConstantesApi.timeoutSeconds * 1000),
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
      throw ApiException(ConstantesApi.errorTimeout);
    }

    // Identificar tipo de endpoint
    String errorNotFound = '';
    if (endpoint.contains(ApiConfig.categoriaEndpoint)) {
      errorNotFound = ConstantesCategorias.errorNocategoria;
    } else if (endpoint.contains(ApiConfig.noticiasEndpoint)) {
      errorNotFound = ConstantesNoticias.errorNotFound;
    }
    //falta los otros endpoints
    final statusCode = e.response?.statusCode;
    
    // Aplicar código de estado al tipo de recurso
    switch (statusCode) {
      case 400:
        return ApiException('Datos inválidos para esta url $endpoint', statusCode: 400);
      case 401:
        return ApiException(ConstantesApi.errorUnauthorized, statusCode: 401);
      case 404:
      //personalizacion
        return ApiException(errorNotFound, statusCode: 404);
      case 500:
        return ApiException(ConstantesApi.errorServer, statusCode: 500);
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
    String errorMessage = 'Error al conectar con la API',
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
    String errorMessage = 'Error al crear el recurso',
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
    String errorMessage = 'Error al actualizar el recurso',
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
    String errorMessage = 'Error al eliminar el recurso',
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
          'No se encontró el token de autenticación',
          statusCode: 401,
        );
      }
    }
    
    return options;
  }
}
