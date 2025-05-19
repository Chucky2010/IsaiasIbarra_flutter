import 'package:flutter/foundation.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

/// BaseRepository proporciona funciones comunes para manejar operaciones
/// de repositorio y errores de una manera consistente.
///
/// Esta clase está diseñada para ser extendida por repositorios específicos
/// en la aplicación, proporcionando métodos útiles para manejar errores,
/// formatear mensajes y validar datos.
abstract class BaseRepository {
  /// Ejecuta una operación y maneja las excepciones de forma consistente.

  Future<T> executeWithTryCatch<T>(
    Future<T> Function() operation,
    String context,
  ) async {
    try {
      return await operation();
    } on ApiException catch (e) {
      // Registrar el error para depuración
      debugPrint('ApiException en $context: ${e.message}');
      throw Exception('Error al $context: ${e.message}');
    } catch (e) {
      // Registrar error genérico
      debugPrint('Error en $context: $e');
      throw Exception('Error al $context: ${e.toString()}');
    }
  }

  /// Verifica si una lista está vacía y opcionalmente lanza una excepción.
  /// 
 List<T> validateListNotEmpty<T>(
    List<T> data,
    String errorMessage, {
    bool throwIfEmpty = true,
  }) {
    if (data.isEmpty && throwIfEmpty) {
      throw ApiException(errorMessage, statusCode: 404);
    }
    return data;
  }

  /// Valida que un objeto no sea nulo.

  T validateNotNull<T>(T? data, String errorMessage) {
    if (data == null) {
      throw ApiException(errorMessage, statusCode: 404);
    }
    return data;
  }

  /// Formatea un mensaje de error con más contexto.
 
  String formatErrorMessage(String baseMessage, String context) {
    return 'Error al $context: $baseMessage';
  }
}