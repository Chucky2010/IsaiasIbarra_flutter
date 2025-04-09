import 'package:mi_proyecto/constants.dart';

class Task {
  final String title;
  final String type;
  final String descripcion;
  DateTime fecha;
  DateTime fechalimite;
  List<String>? pasos = [];

  Task({
    required this.title,
    this.type = 'normal',
    required this.descripcion,
    required this.fecha,
    required this.fechalimite,
    this.pasos = const []
  });
}
