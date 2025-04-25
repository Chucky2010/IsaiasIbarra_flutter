// category.dart
class Categoria {
  final String? id; // ID asignado por la API (opcional, para operaciones CRUD)
  final String nombre; // Nombre de la categoría (por ejemplo, "Inteligencia Artificial")
  final String descripcion; // Descripción breve (por ejemplo, "Noticias sobre IA")
  final String imagenUrl; // URL de la imagen representativa de la categoría

  Categoria({
    this.id, // Puede ser null al crear una categoría, se asigna al guardarla
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
  });

  // Método para convertir un JSON de la API a un objeto Category
  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['_id'] as String?, // El ID lo asigna CrudCrud
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      imagenUrl: json['imagenUrl'] as String,
    );
  }

  // Método para convertir el objeto Categoria a JSON para enviar a la API
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'imagenUrl': imagenUrl,
    };
  }
}
