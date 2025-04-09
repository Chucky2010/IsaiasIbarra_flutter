import 'package:mi_proyecto/constants.dart';

class AssistantRepository {


  List<String> generarPasos(String titulo, DateTime fechaLimite) {
    final String fechaFormateada =
        '${fechaLimite.day.toString().padLeft(2, '0')}/${fechaLimite.month.toString().padLeft(2, '0')}/${fechaLimite.year}';

    return [
      'Paso 1: Planificar $titulo antes del $fechaFormateada',
      'Paso 2: Ejecutar $titulo antes del $fechaFormateada',
      'Paso 3: Revisar $titulo antes del $fechaFormateada',
    ];
  }

  
}