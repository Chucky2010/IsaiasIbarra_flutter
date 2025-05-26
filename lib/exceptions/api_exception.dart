class ApiException implements Exception {
  final String message;

  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  //si le pasas el toString, muestra el mensaje
  String toString() {
    return 'ApiException: $message (Código: $statusCode)';
  }
}
