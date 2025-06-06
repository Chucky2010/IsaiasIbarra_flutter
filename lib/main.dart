import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mi_proyecto/bloc/auth/auth_bloc.dart';
import 'package:mi_proyecto/bloc/comentario/comentario_bloc.dart';
import 'package:mi_proyecto/bloc/reporte/reporte_bloc.dart';
import 'package:mi_proyecto/bloc/tarea/tarea_bloc.dart';
import 'package:mi_proyecto/bloc/theme/theme_bloc.dart';
import 'package:mi_proyecto/bloc/theme/theme_event.dart';
import 'package:mi_proyecto/bloc/theme/theme_state.dart';
import 'package:mi_proyecto/di/locator.dart';
import 'package:mi_proyecto/bloc/contador/contador_bloc.dart';
import 'package:mi_proyecto/bloc/connectivity/connectivity_bloc.dart';
import 'package:mi_proyecto/components/connectivity_wrapper.dart';
import 'package:mi_proyecto/helpers/secure_storage_service.dart';
import 'package:mi_proyecto/helpers/shared_preferences_service.dart';
import 'package:mi_proyecto/theme/theme.dart';
import 'package:mi_proyecto/views/login_screen.dart';
import 'package:watch_it/watch_it.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_bloc.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Cargar variables de entorno
    await dotenv.load(fileName: ".env");
    
    // Inicializar servicios y dependencias
    await initLocator();
    await SharedPreferencesService().init();
    
    // Limpiar datos de sesión anterior
    final secureStorage = di<SecureStorageService>();
    await secureStorage.clearJwt();
    await secureStorage.clearUserEmail();
    
    // Inicializar ThemeBloc y cargar preferencia de tema
    final themeBloc = ThemeBloc()..add(InitializeThemeEvent());

    runApp(MyApp(themeBloc: themeBloc));
  } catch (e) {
    debugPrint('Error durante la inicialización: $e');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Error al iniciar la aplicación: $e'),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  final ThemeBloc themeBloc;
  
  const MyApp({super.key, required this.themeBloc});
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContadorBloc>(create: (context) => ContadorBloc()),
        BlocProvider<ConnectivityBloc>(create: (context) => ConnectivityBloc()),
        BlocProvider(create: (context) => ComentarioBloc()),
        BlocProvider(create: (context) => ReporteBloc()),
        BlocProvider(create: (context) => AuthBloc()),
        // Agregamos NoticiaBloc como un provider global para mantener el estado entre navegaciones
        BlocProvider<NoticiaBloc>(create: (context) => NoticiaBloc()),
        BlocProvider<TareaBloc>(
          create: (context) => TareaBloc(),
          lazy: false, // Esto asegura que el bloc se cree inmediatamente
        ),
        // Proveedor para el ThemeBloc
        BlocProvider<ThemeBloc>.value(value: themeBloc),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              // Envolvemos con nuestro ConnectivityWrapper
              return ConnectivityWrapper(child: child ?? const SizedBox.shrink());
            },
            home: LoginScreen(), // Pantalla inicial
          );
        }
      ),
    );
  }
}
