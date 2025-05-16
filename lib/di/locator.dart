import 'package:mi_proyecto/bloc/comentarios/comentario_bloc.dart';
import 'package:mi_proyecto/bloc/reportes/reportes_bloc.dart';
import 'package:mi_proyecto/data/auth_repository.dart';
import 'package:mi_proyecto/data/categorias_repository.dart';
import 'package:mi_proyecto/data/noticia_repository.dart';
import 'package:mi_proyecto/data/preferencia_repository.dart';
import 'package:mi_proyecto/data/reporte_repository.dart';
import 'package:mi_proyecto/helpers/secure_storage_service.dart';
import 'package:mi_proyecto/helpers/connectivity_service.dart';
import 'package:mi_proyecto/api/service/category_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'package:mi_proyecto/data/comentario_repository.dart';

Future<void> initLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerSingleton<NoticiaRepository>(NoticiaRepository());
  di.registerLazySingleton<PreferenciaRepository>(
    () => PreferenciaRepository(),
  );
  di.registerSingleton<ComentarioRepository>(ComentarioRepository());  di.registerSingleton<ReporteRepository>(ReporteRepository());  di.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );
  // Registramos el servicio de conectividad
  di.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(),
  );
  GetIt.instance.registerSingleton(ComentarioBloc());
  // Cambiamos a registerFactory para generar una nueva instancia cada vez que sea solicitada
  GetIt.instance.registerFactory(() => ReporteBloc());  di.registerSingleton<AuthRepository>(AuthRepository());
  
  // Registramos el servicio de caché de categorías como singleton
  di.registerLazySingleton<CategoryCacheService>(() => CategoryCacheService());
}
