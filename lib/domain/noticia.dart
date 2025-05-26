import 'package:dart_mappable/dart_mappable.dart';
part 'noticia.mapper.dart';

@MappableClass()
class Noticia with NoticiaMappable{
  final String? id; 
  final String titulo;
  final String descripcion;
  final String fuente;
  final DateTime publicadaEl;
  final String urlImagen; 
  final String? categoriaId; 
  final int? contadorReportes;
  final int? contadorComentarios;

  Noticia({
    this.id, 
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.urlImagen,
    this.categoriaId, 
    this.contadorReportes,
    this.contadorComentarios,
  });
}