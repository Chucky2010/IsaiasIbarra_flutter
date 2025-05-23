import 'package:dart_mappable/dart_mappable.dart';

part 'task.mapper.dart';

@MappableClass()
class Task with TaskMappable{
  
  final String titulo;
  final String tipo;
  final String? descripcion;
  final DateTime? fecha;
  final DateTime? fechaLimite; // Nueva fecha límite
  final List<String>? pasos; // Nuevos pasos

  Task({
    required this.titulo,
    this.tipo = 'normal', // Valor por defecto
    this.descripcion,
    this.fecha,
    this.fechaLimite,
    this.pasos,
  });
}