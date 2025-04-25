import 'package:mi_proyecto/constants.dart';

class Noticia {
  final String id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final DateTime publicadaEl;
  final String imageUrl;
  final String categoriaId;

  Noticia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.imageUrl,
    required this.categoriaId,
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
      categoriaId: json['categoriaId'] ?? Constants.defaultcategoriaId,
    );
  }

Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'fuente': fuente,
      'publicadaEl': publicadaEl.toIso8601String(),
      'urlImagen': imageUrl,
      'categoriaId': categoriaId,
    };
  }

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is Noticia && runtimeType == other.runtimeType && id == other.id;

  // @override
  // int get hashCode => id.hashCode;
}
