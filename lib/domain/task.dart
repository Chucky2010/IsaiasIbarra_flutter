
class Task {
  final String title;
  final String type;
  final String descripcion;
  DateTime fecha;
  DateTime deadline;
  List<String>? steps;

  Task({
    required this.title,
    this.type = 'normal',
    required this.descripcion,
    required this.fecha,
    required this.deadline,
    this.steps = const [],
  });

  String get getTitle => title;
   String get getType => type;
   String get getDescription => descripcion;
   DateTime get getDate => fecha;
   DateTime get getFechalimite => deadline;
   List<String>? get getPasos => steps;

   String fechaLimiteToString() {
     return '${deadline.day}/${deadline.month}/${deadline.year}';
   }

   String fechaToString() {
     return '${fecha.day}/${fecha.month}/${fecha.year}';
   }

void setPasos(List<String> pasos) {
     if (steps == null || steps!.isEmpty) {
       steps = pasos;
     }
   }


}
