import 'package:mi_proyecto/constants.dart';

class Task {
  final String title;
  final String type;
  final String descripcion;
  DateTime fecha;
  DateTime fechalimite;
  List<String> pasos = [];

  Task({
    required this.title, 
    this.type = 'normal', 
  required this.descripcion, 
  required this.fecha,
  DateTime? fechalimite,
  this.pasos = LISTAS_PASOS_VACIA,
  }) : fechalimite = fechalimite ?? DateTime.now().add(const Duration(days: 7)); // Asigna una fecha límite por defecto si no se proporciona
} 