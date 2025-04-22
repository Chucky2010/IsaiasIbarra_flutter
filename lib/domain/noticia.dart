class Noticia {
  //final String id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final DateTime publicadaEl;
  final String imageUrl;

  Noticia({
    //required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.imageUrl,
  });

  // Método para mapear datos JSON al modelo Noticia
  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      //id: json['url'],
      titulo: json['title'] ?? 'Sin título',
      descripcion: json['description'] ?? 'Sin descripción',
      fuente: json['source']['name'] ?? 'Fuente desconocida',
      publicadaEl: DateTime.parse(json['publishedAt']),
      imageUrl: json['urlToImage'] ?? 'https://via.placeholder.com/150',
    );
  }
}
