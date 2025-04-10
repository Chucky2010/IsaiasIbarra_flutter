import 'package:mi_proyecto/constants.dart';

class AssistantRepository {
   final List<String> _pasosSimulados = [
     'Paso 1: Planificar ',
     'Paso 2: Ejecutar ',
     'Paso 3: Revisar ',
   ];
 
   List<String> getListaPasos() {
     return _pasosSimulados; // Devuelve la lista de pasos simulados
   }
 
   // Obtener pasos simulados para una tarea según su título
   List<String> obtenerPasos(String titulo, String fechaLimite) {
     return [
       for (String paso in AssistantRepository().getListaPasos())
         '$paso$titulo antes de $fechaLimite',
     ];
   }
 }