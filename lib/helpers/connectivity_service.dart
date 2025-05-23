import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

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
      throw ApiException(ConectividadConstantes.mensajeSinConexion,
        statusCode: 503
      );
    }
  }
}