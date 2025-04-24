class Noticia {
  final String id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final DateTime publicadaEl;
  final String imageUrl;

  Noticia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.imageUrl,
  });

  // Método para mapear datos JSON al modelo Noticia
  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['_id'] ?? 'Sin ID',
      titulo: json['titulo'] ?? 'Sin título',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      fuente: json['fuente'] ?? 'Fuente desconocida',
      publicadaEl: DateTime.parse(json['publicadaEl']),
      imageUrl: json['urlImagen'] ?? 'https://via.placeholder.com/150',
    );
  }
 @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Noticia &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
  
}
