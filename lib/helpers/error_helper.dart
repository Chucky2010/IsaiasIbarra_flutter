import 'package:flutter/material.dart';
import 'package:kgaona/constants/constantes.dart';

class ErrorHelper {
  /// Devuelve un mensaje y un color basado en el código HTTP
  static Map<String, dynamic> getErrorMessageAndColor(
    int? statusCode, 
    {String? customMessage}
  ) {
    String message;
    Color color;
      switch (statusCode) {
      case 400:
        message = 'Solicitud incorrecta. Verifica los datos enviados.';
        color = Colors.red;
        break;
      case 401:
        message = ConstantesApi.errorUnauthorized;
        color = Colors.orange;
        break;
      case 403:
      case 562:
        message = 'Prohibido. No tienes permisos para acceder.';
        color = Colors.redAccent;
        break;
      case 404:
        message = ConstantesNoticias.errorNotFound;
        color = Colors.grey;
        break;
      case 500:
        message = ConstantesApi.errorServer;
        color = Colors.red;
        break;
      case 503:
        message = 'Por favor, verifica tu conexión a internet.';
        color = Colors.red;
        break;
      default:
        message = 'Ocurrió un error desconocido.';
        color = Colors.purple;
        break;
    }
  
    // Permitir sobrescribir el mensaje si se proporciona uno personalizado
    if (customMessage != null) {
      message = customMessage;
    }
  
    return {'message': message, 'color': color};
  }
}
