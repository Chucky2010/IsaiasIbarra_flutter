import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:kgaona/helpers/snackbar_helper.dart';

/// Servicio para verificar la conectividad a Internet
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  /// Verifica si el dispositivo tiene conectividad a Internet
  /// Retorna true si hay conexión, false en caso contrario
  Future<bool> hasInternetConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any((result) => result != ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  /// Verifica la conectividad y lanza una excepción si no hay conexión
  Future<void> checkConnectivity() async {
    if (!await hasInternetConnection()) {
      //pasar a constante
      throw ApiException('Por favor, verifica tu conexión a internet.', 
        statusCode: 503
      );
    }
  }
  /// Muestra un SnackBar con un mensaje de error de conectividad que permanece hasta que hay conexión
  void showConnectivityError(BuildContext context) {
    SnackBarHelper.manejarError(
      context, 
      'Por favor, verifica tu conexión a internet.',
      duration: const Duration(days: 1) // Virtualmente infinito
    );
  }
}