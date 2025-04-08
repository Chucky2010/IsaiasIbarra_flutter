class Task {
  final String title;
  final String type;
  final String descripcion;
  DateTime fecha;

  Task({required this.title, this.type = 'normal', required this.descripcion, required this.fecha});
}
