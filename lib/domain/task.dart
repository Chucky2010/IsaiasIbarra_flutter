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

  String get getTitle => title;
   String get getType => type;
   String get getDescription => descripcion;
   DateTime get getDate => fecha;
   DateTime get getFechalimite => fechalimite;
   List<String>? get getPasos => pasos;

   String fechaLimiteToString() {
     return '${fechalimite.day}/${fechalimite.month}/${fechalimite.year}';
   }

   String fechaToString() {
     return '${fecha.day}/${fecha.month}/${fecha.year}';
   }



}
