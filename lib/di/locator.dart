import 'package:mi_proyecto/api/service/tarea_service.dart';
import 'package:mi_proyecto/bloc/reporte/reporte_bloc.dart';
import 'package:mi_proyecto/data/auth_repository.dart';
import 'package:mi_proyecto/data/categoria_repository.dart';
import 'package:mi_proyecto/data/comentario_repository.dart';
import 'package:mi_proyecto/data/noticia_repository.dart';
import 'package:mi_proyecto/data/preferencia_repository.dart';
import 'package:mi_proyecto/data/reporte_repository.dart';
import 'package:mi_proyecto/data/tarea_repository.dart';
import 'package:mi_proyecto/helpers/connectivity_service.dart';
import 'package:mi_proyecto/helpers/secure_storage_service.dart';
import 'package:mi_proyecto/helpers/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

Future<void> initLocator() async {
  // Registrar primero los servicios básicos
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerLazySingleton<SharedPreferencesService>(() => SharedPreferencesService());
  di.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  di.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  
  // Servicios de API
  di.registerLazySingleton<TareaService>(() => TareaService());
  
  // Repositorios
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerLazySingleton<PreferenciaRepository>(() => PreferenciaRepository());
  di.registerLazySingleton<NoticiaRepository>(() => NoticiaRepository());
  di.registerLazySingleton<ComentarioRepository>(() => ComentarioRepository());
  di.registerLazySingleton<AuthRepository>(() => AuthRepository());
  di.registerSingleton<ReporteRepository>(ReporteRepository());
  di.registerLazySingleton<TareasRepository>(() => TareasRepository());
  
  // BLoCs
  di.registerFactory<ReporteBloc>(() => ReporteBloc());
}