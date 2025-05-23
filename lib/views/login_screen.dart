import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/auth/auth_bloc.dart';
import 'package:mi_proyecto/bloc/auth/auth_event.dart';
import 'package:mi_proyecto/bloc/auth/auth_state.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_bloc.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_event.dart';
import 'package:mi_proyecto/components/snackbar_component.dart';
import 'package:mi_proyecto/views/welcome_screen.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            // Mostrar indicador de carga
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else if (state is AuthAuthenticated) {
            // Cerrar diálogo de carga si está abierto
            Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
            
            // Cargar noticias para el nuevo usuario
            context.read<NoticiaBloc>().add(FetchNoticiasEvent());
            
            // Navegar a la pantalla principal
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          } else if (state is AuthFailure) {
            // Cerrar diálogo de carga si está abierto
            Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
            
            // Mostrar error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBarComponent.crear(
                mensaje: state.error.message,
                color: Colors.red,
                duracion: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
              const Text(
                  'Inicio de Sesión',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuario *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El correo es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña *',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La contraseña es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final username = usernameController.text.trim();
                    final password = passwordController.text.trim();

                    // Usar el BLoC para manejar la autenticación
                    context.read<AuthBloc>().add(
                      AuthLoginRequested(
                        email: username,
                        password: password,
                      ),
                    );
                  }
                },
                child: const Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
          },
        ),
      );
    }
}
