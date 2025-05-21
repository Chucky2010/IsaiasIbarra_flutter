import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // Configuración para Beeceptor
  static String get beeceptorApiKey => dotenv.env['BEECEPTOR_API_KEY'] ?? '';
  static String get beeceptorApiServer => dotenv.env['BEECEPTOR_API_SERVER'] ?? '';
  static final String beeceptorBaseUrl = 'https://$beeceptorApiServer.proxy.beeceptor.com/api';
    // Rutas para los endpoints específicos en Beeceptor
  static const String categoriaEndpoint = '/categorias';
  static const String noticiasEndpoint = '/noticias';
  static const String preferenciasEndpoint = '/preferenciasEmail';
  static const String comentariosEndpoint = '/comentarios';
  static const String reportesEndpoint = '/reportes';
}
