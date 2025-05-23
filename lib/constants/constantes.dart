class ComentarioConstantes {
  static const String mensajeCargando = 'Cargando comentarios...';
  static const String listaVacia = 'No hay comentarios disponibles';
  static const String errorNotFound = 'Comentario no encontrado';
  static const String successCreated = 'Comentario agregado exitosamente';
  static const String successReaction = 'Reacción registrada exitosamente';
  static const String successSubcomentario = 'Subcomentario agregado exitosamente';
  static const String errorServer = 'Error del servidor en comentario';
  static const String mensajeError = 'Error al obtener comentarios';
  static const String errorUnauthorized = 'No autorizado para acceder a comentario';
  static const String errorInvalidData = 'Datos inválidos en comentario';
}

class CategoriaConstantes{
  static const String tituloApp = 'Categorías de Noticias';
  static const String mensajeCargando = 'Cargando categorias...';
  static const String listaVacia = 'No hay categorias disponibles';
  static const String mensajeError = 'Error al obtener categorías';
  static const String errorNocategoria = 'Categoría no encontrada';
  static const String defaultcategoriaId = 'Sin Categoria';
  static const String successUpdated = 'Categoria actualizada exitosamente';
  static const String errorUpdated = 'Error al editar la categoría';
  static const String successDeleted = 'Categoria eliminada exitosamente';
  static const String errorDelete = 'Error al eliminar la categoría';
  static const String errorAdd = 'Error al agregar categoría';
  static const String successCreated = 'Categoria creada exitosamente';
  static const String errorCreated = 'Error al crear la categoría';
  static const String errorUnauthorized = 'No autorizado para acceder a categoría';
  static const String errorInvalidData = 'Datos inválidos en categoria';
  static const String errorServer = 'Error del servidor en categoria';
}

class ReporteConstantes {
  static const String reporteCreado = 'Reporte enviado con éxito';
  static const String noticiaNoExiste = 'La noticia reportada no existe';
  static const String errorCrearReporte = 'Error al crear el reporte';
  static const String errorObtenerReportes = 'Error al obtener reportes';
  static const String listaVacia = 'No hay reportes disponibles';
  static const String mensajeCargando = 'Cargando reportes...';
  static const String errorUnauthorized = 'No autorizado para acceder a reporte';
  static const String errorInvalidData = 'Datos inválidos en reporte';
  static const String errorServer = 'Error del servidor en reporte';
  static const String errorNotFound = 'Reporte no encontrado';
}


// Constantes generales de la aplicación
class AppConstantes {
  static const int timeoutSeconds = 10;
  static const String formatoFecha = 'dd/MM/yyyy HH:mm';
  static const int pageSize = 10;
  static const double espaciadoAlto = 10;
  static const String errorTimeOut = 'Tiempo de espera agotado';
  static const String usuarioDefault = 'Usuario anonimo';
  static const String errorServer = 'Error del servidor';//
  static const String errorUnauthorized = 'Se requiere autenticación';//
  static const String errorNoInternet = 'Sin conexión a Internet';//
  static const String errorInvalidData = 'Datos inválidos';//
  static const String tokenNoEncontrado = 'No se encontró el token de autenticación';
  static const String errorDeleteDefault = 'Error al eliminar el recurso';
  static const String errorUpdateDefault = 'Error al actualizar el recurso';
  static const String errorCreateDefault = 'Error al crear el recurso';  
  static const String errorGetDefault = 'Error al obtener el recurso';  
  static const String errorAccesoDenegado = 'Acceso denegado. Verifique su API key o IP autorizada';
  static const String limiteAlcanzado = 'Límite de peticiones alcanzado. Intente más tarde';
  static const String errorServidorMock = 'Error en la configuración del servidor mock';
  static const String errorConexionProxy = 'Error de conexión con el servidor proxy';
  static const String conexionInterrumpida = 'La conexión fue interrumpida';
  static const String errorRecuperarRecursos = 'Error al recuperar recursos del servidor';
  static const String errorCriticoServidor = 'Error crítico en el servidor';
  static const String notUser = 'No hay usuario autenticado';
  static const String errorCache = 'Error al actualizar caché local';
}

class ApiConstantes {
  static const String categoriaEndpoint = '/categorias';
  static const String noticiasEndpoint = '/noticias';
  static const String preferenciasEndpoint = '/preferenciasEmail';
  static const String comentariosEndpoint = '/comentarios';
  static const String reportesEndpoint = '/reportes';
}

// Constantes para la pantalla de Tareas
class TareasConstantes {
  static const String tituloAppBar = 'Mis Tareas';
  static const String listaVacia = 'No hay tareas';
  static const String tipoTarea = 'Tipo: ';
  static const String taskTypeNormal = 'normal';
  static const String taskTypeUrgent = 'urgente';
  static const String taskDescription = 'Descripción: ';
  static const String pasosTitulo = 'Pasos para completar: ';
  static const String fechaLimite = 'Fecha límite: ';
  static const String tareaEliminada = 'Tarea eliminada';
  static const int limitePasos = 2;
  static const int limiteTareas = 10;
}

// Constantes para el Juego de Preguntas
class PreguntasConstantes {
  static const String titleApp = 'Juego de Preguntas';
  static const String welcomeMessage = '¡Bienvenido al Juego de Preguntas!';
  static const String startGame = 'Iniciar Juego';
  static const String finalScoreQuestions = 'Puntuación Final: ';
  static const String playAgain = 'Jugar de nuevo';
  static const String results = 'Resultados';
}

// Constantes para Cotizaciones (Quotes)
class CotizacionConstantes {
  static const String titleApp = 'Cotizaciones Financieras';
  static const String loadingMessage = 'Cargando cotizaciones...';
  static const String emptyList = 'No hay cotizaciones';
  static const String errorMessage = 'Error al cargar cotizaciones';
  static const int pageSize = 12;
  static const String nombreEmpresa = 'Empresa: ';
}

// Constantes para Noticias y Categorías
class NoticiasConstantes {
  static const String tituloApp = 'Noticias Técnicas';
  static const String mensajeCargando = 'Cargando noticias...';
  static const String listaVacia = 'No hay noticias disponibles';
  static const String mensajeError = 'Error al obtener noticias';
  static const String defaultCategoriaId = 'default';
  static const String errorNotFound = 'Noticia no encontrada';
  static const String successUpdated = 'Noticia actualizada exitosamente';
  static const String successCreated = 'Noticia creada exitosamente';
  static const String successDeleted = 'Noticia eliminada exitosamente';
  static const String errorUnauthorized = 'No autorizado para acceder a noticia';
  static const String errorInvalidData = 'Datos inválidos en noticia';
  static const String errorServer = 'Error del servidor en noticia';
  static const String errorCreated = 'Error al crear la noticia';
  static const String errorUpdated = 'Error al editar la noticia';
  static const String errorDelete = 'Error al eliminar la noticia';
  static const String errorFilter = "Error al filtrar noticias";
}

class ConectividadConstantes {
  static const String mensajeSinConexion = 'Por favor, verifica tu conexión a internet.';
  static const String mensajeReconectando = 'Intentando reconectar...';
  static const String mensajeReconectado = 'Conexión restablecida';
  static const int intentosReconexion = 3;
  static const int tiempoEsperaReconexion = 5000; // milisegundos
  static const String tituloModoOffline = 'Modo sin conexión';
  static const String mensajeDinosaurio = 'Oh no! Parece que estás sin conexión';
}

class ValidacionConstantes {
  // Mensajes genéricos
  static const String campoVacio = ' no puede estar vacío';
  static const String noFuturo = ' no puede estar en el futuro.';
  // static const String campoInvalido = 'no es válido';
  // static const String campoMuyCorto = 'es demasiado corto';
  // static const String campoMuyLargo = 'es demasiado largo';
  
  // Campos comunes
  static const String imagenUrl = 'URL de la imagen';
  // static const String nombre = 'nombre';
  // static const String descripcion = 'descripción';
  // static const String imagen = 'imagen';
  // static const String url = 'URL';
  // static const String titulo = 'título';
  // static const String fecha = 'fecha';
  static const String email = 'email del usuario';
  // static const String precio = 'precio';
  // static const String cantidad = 'cantidad';
  
  // Campos específicos
  static const String nombreCategoria = 'El nombre de la categoría';
  static const String descripcionCategoria = 'La descripción de la categoría';
  static const String tituloNoticia = 'El título de la noticia';
  static const String descripcionNoticia = 'La descripción de la noticia';
  static const String fuenteNoticia = 'La fuente de la noticia';
  static const String fechaNoticia = 'La fecha de la publicación de la noticia';
}

class PreferenciaConstantes {
  static const String mensajeError = 'Error al obtener categorías';
  // static const String mensajeCargando = 'Cargando preferencias...';
  // static const String listaVacia = 'No hay preferencias disponibles';
  // static const String errorNoPreferencia = 'Preferencia no encontrada';
  // static const String successUpdated = 'Preferencia actualizada exitosamente';
  static const String errorUpdated = 'Error al guardar preferencias';
  // static const String successCreated = 'Preferencia creada exitosamente';
  static const String errorCreated = 'Error al crear la preferencia';
  static const String errorServer = 'Error del servidor en preferencia';
  static const String errorUnauthorized = 'No autorizado para acceder a preferencia';
  static const String errorInvalidData = 'Datos inválidos en preferencia';
  static const String errorNotFound = 'Preferencia no encontrada';
  static const String errorInit = 'Error al inicializar preferencias';
}