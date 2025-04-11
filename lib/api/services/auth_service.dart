import 'dart:async';
class AuthService {
  Future<void> login(String username, String password) async {
    // Simula un retraso como si estuvieras haciendo una llamada a una API
    await Future.delayed(const Duration(seconds: 2));

    // Imprime las credenciales en la consola
    print('Usuario: $username');
    print('Contraseña: $password');

    // Aquí puedes agregar lógica adicional, como validar las credenciales
    // o devolver un token simulado.
  }
}