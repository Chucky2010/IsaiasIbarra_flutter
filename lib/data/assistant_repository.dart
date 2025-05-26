class AssistantRepository {
  Future<List<String>> generarPasos(String tituloTarea, DateTime? fechaLimite) async {
    // Simula un retraso para imitar una consulta a un asistente de IA
    await Future.delayed(const Duration(milliseconds: 500));

    // Convierte la fecha límite a una cadena que solo muestra la fecha
    final String fechaFormateada = fechaLimite != null
        //? fechaLimite.toIso8601String().split('T')[0] // Obtiene solo la parte de la fecha
        ? '${fechaLimite.day.toString().padLeft(2, '0')}/${fechaLimite.month.toString().padLeft(2, '0')}/${fechaLimite.year}'
        : 'sin fecha límite';

    // Genera pasos personalizados basados en el título de la tarea y la fecha límite
    return [
      'Paso 1: Planificar $tituloTarea antes del $fechaFormateada',
      'Paso 2: Ejecutar $tituloTarea antes del $fechaFormateada',
      'Paso 3: Revisar $tituloTarea antes del $fechaFormateada',
    ];
  }
}