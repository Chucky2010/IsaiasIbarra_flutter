import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String titleAppbar = 'Mis Tareas';
  static const String listaTareasVacia = 'No hay tareas.';
  static const String taskTypeNormal = 'normal';
  static const String pasosTitulo = 'Pasos para completar:';
  static const String fechaLimite = 'Fecha límite:';
  static const String taskTypeUrgent = 'urgente';
  static const String taskDescription = 'Descripción:';
  static const String tareaEliminada = 'Tarea eliminada';
  static const String tipoTarea = 'Tipo: ';

  static const String titleAppGame = 'Juego de Preguntas';
  static const String welcomeMessage = '¡Bienvenido al Juego de Preguntas!';
  static const String startGame = 'Iniciar Juego';
  static const String finalScore = 'Puntuación Final: ';
  static const String playAgain = 'Jugar de Nuevo';

  static const String titleApp = 'Cotizaciones Financieras';
  static const String loadingMessage = 'Cargando cotizaciones...';
  static const String emptyList = 'No hay cotizaciones';
  static const String errorMessage = 'Error al cargar las cotizaciones';
  static const int pageSize = 10;
  static const String dateFormat = 'dd/MM/yyyy HH:mm';

  static const String tituloApp = 'Noticias Técnicas';
  static const String mensajeCargando = 'Cargando noticias...';
  static const String listaVacia = 'No hay noticias disponibles';
  static const String mensajeError = 'Error al cargar noticias';
  static const String formatoFecha = 'dd/MM/yyyy HH:mm';
  static const int tamanoPaginaConst = 5;
  static const double espaciadoAlto = 10;
  static const String tooltipOrden = 'Cambiar orden';

  static const String apiKey = 'a8432d716d454b6ab80e8921f881be9f';
  static const String newUrl = 'https://crudcrud.com/api';

  //static const String baseUrl = 'https://crudcrud.com/api/a8432d716d454b6ab80e8921f881be9f/noticias';
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://default-url.com';

  static String get urlNoticias => '$baseUrl/noticias';
  static String get urlCategorias => '$baseUrl/categorias';

  static const String noticiasEndpoint= '/noticias';
  static const String categoriasEndpoint= '/categorias';
  static const int timeoutSeconds = 10; // Tiempo de espera para la conexión
  static const String errorTimeout = 'Tiempo de espera agotado';
  static const String errorNocategoria ='Categoría no encontrada';
  static const String defaultcategoriaId = 'sin_categoria';

  static const errorUnauthorized= 'No autorizado';
  static const errorNotFound= 'Noticias no encontradas';
  static const errorServer= 'Error del servidor';
  
}
