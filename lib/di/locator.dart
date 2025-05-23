import 'package:mi_proyecto/bloc/reporte/reporte_bloc.dart';
import 'package:mi_proyecto/data/auth_repository.dart';
import 'package:mi_proyecto/data/categoria_repository.dart';
import 'package:mi_proyecto/data/comentario_repository.dart';
import 'package:mi_proyecto/data/noticia_repository.dart';
import 'package:mi_proyecto/data/preferencia_repository.dart';
import 'package:mi_proyecto/data/reporte_repository.dart';
import 'package:mi_proyecto/helpers/connectivity_service.dart';
import 'package:mi_proyecto/helpers/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

Future<void> initLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerLazySingleton<PreferenciaRepository>(() => PreferenciaRepository());  
  di.registerLazySingleton<NoticiaRepository>(() => NoticiaRepository());
  di.registerLazySingleton<ComentarioRepository>(() => ComentarioRepository());
  di.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  di.registerLazySingleton<AuthRepository>(() => AuthRepository());
  di.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  di.registerSingleton<ReporteRepository>(ReporteRepository());
  di.registerFactory<ReporteBloc>(() => ReporteBloc());
}