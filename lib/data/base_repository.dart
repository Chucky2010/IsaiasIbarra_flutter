import 'package:flutter/foundation.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

/// Repositorio base que proporciona funcionalidades comunes para todos los repositorios
abstract class BaseRepository {
  /// Maneja errores comunes y proporciona un mensaje claro
  ///
  /// [error] - La excepción capturada
  /// [operacion] - Descripción de la operación que falló (ej: "al obtener noticias")
  /// [entidad] - El nombre de la entidad con la que se trabaja (ej: "noticia")
  Future<Never> handleError(
    dynamic error,
    String operacion,
    String entidad,
  ) async {
    debugPrint('❌ Error $operacion: ${error.toString()}');

    if (error is ApiException) {
      throw ApiException(
        'Error $operacion: ${error.message}',
        statusCode: error.statusCode,
      );
    }

    throw ApiException('Error inesperado $operacion');
  }

  /// Verifica si un id está vacío o es nulo, lanzando una excepción en caso afirmativo
  ///
  /// [id] - El ID a verificar
  /// [entidad] - El nombre de la entidad para el mensaje de error (ej: "noticia")
  void checkIdNotEmpty(String? id, String entidad) {
    if (id == null || id.isEmpty) {
      throw ApiException(
        'El ID de $entidad no puede estar vacío',
        statusCode: 400,
      );
    }
  }

  /// Verifica si un campo obligatorio está vacío o es nulo, lanzando una excepción en caso afirmativo
  ///
  /// [valor] - El valor a verificar
  /// [nombreCampo] - El nombre del campo para el mensaje de error
  void checkFieldNotEmpty(String? valor, String nombreCampo) {
    if (valor == null || valor.isEmpty) {
      throw ApiException(
        'El campo $nombreCampo no puede estar vacío',
        statusCode: 400,
      );
    }
  }

  /// Verifica si una lista está vacía, devolviendo un valor por defecto o lanzando una excepción
  ///
  /// [lista] - La lista a verificar
  /// [entidad] - El nombre de la entidad para el mensaje (ej: "noticias")
  /// [lanzarError] - Si es true, lanza una excepción cuando la lista está vacía
  /// [valorPorDefecto] - El valor por defecto a devolver si la lista está vacía y no se lanza error
  T checkListNotEmpty<T>(
    List<dynamic>? lista,
    String entidad, {
    bool lanzarError = false,
    T? valorPorDefecto,
  }) {
    if (lista == null || lista.isEmpty) {
      if (lanzarError) {
        throw ApiException('No se encontraron $entidad', statusCode: 404);
      }
      return valorPorDefecto as T;
    }
    return lista as T;
  }

  /// Registra el inicio de una operación para debugging
  void logOperationStart(
    String operacion,
    String entidad, [
    String? idOpcional,
  ]) {
    final idStr = idOpcional != null ? ' con ID: $idOpcional' : '';
    debugPrint('🔄 Iniciando $operacion $entidad$idStr');
  }

  /// Registra el éxito de una operación para debugging
  void logOperationSuccess(
    String operacion,
    String entidad, [
    String? idOpcional,
  ]) {
    final idStr = idOpcional != null ? ' con ID: $idOpcional' : '';
    debugPrint('✅ $entidad$idStr ${operacion.toLowerCase()} exitosamente');
  }
}