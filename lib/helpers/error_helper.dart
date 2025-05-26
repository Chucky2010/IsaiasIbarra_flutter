import 'package:flutter/material.dart';

class ErrorHelper {
  /// Devuelve un mensaje y un color basado en el código HTTP
  static Color getErrorColor(int statusCode) {
    Color color;
    switch (statusCode) {
      case 400:
        color = Colors.red;
        break;
      case 401:
        color = Colors.orange;
        break;
      case 403:
      case 562:
        color = Colors.redAccent;
        break;
      case 404:
        color = Colors.grey;
        break;
      case 429:
        // Límite de tasa alcanzado (Rate Limit) - Color amarillo ámbar
        color = Colors.amber;
        break;
      case 500:
        // Error interno del servidor (Internal Server Error) - Color rojo
        color = Colors.red;
        break;
      case 503:
        // Servicio no disponible (Service Unavailable) - Color rojo
        color = Colors.red;
        break;
      case 561:
        // Error en plantilla de respuesta Beeceptor - Color rosa
        color = Colors.pink;
        break;
      case 571:
      case 572:
      case 573:
      case 574:
      case 575:
      case 576:
      case 577:
      case 578:
        // Errores de conexión proxy Beeceptor - Color cian
        color = Colors.cyan;
        break;
      case 580:
        // Cliente desconectado (socket hang up) - Color azul
        color = Colors.blue;
        break;
      case 581:
        // Error al recuperar archivo Beeceptor - Color verde lima
        color = Colors.lime;
        break;
      case 599:
        // Error crítico en Beeceptor - Color rojo oscuro
        color = Colors.red[900]!;
        break;
      default:
        color = Colors.purple;
        break;
    }
    return  color;
  }
}
