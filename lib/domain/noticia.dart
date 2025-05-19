import 'package:dart_mappable/dart_mappable.dart';

part 'noticia.mapper.dart';

@MappableClass()
class Noticia with NoticiaMappable{
  //@JsonKey(includeIfNull: false)
  final String? id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final DateTime publicadaEl;
  final String urlImagen;
  final String? categoriaId; // ID de la categoría asociada

  Noticia({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.urlImagen,
    this.categoriaId, // Valor por defecto
  });

}
