import 'dart:math';
import 'package:mi_proyecto/domain/noticia.dart';
import 'package:dio/dio.dart';
import 'package:mi_proyecto/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NoticiaRepository {
  final Dio _dio = Dio();
  // final String _baseUrl =
  //     'https://crudcrud.com/api/a8432d716d454b6ab80e8921f881be9f/noticias';

  final String _baseUrl = Constants.baseUrl; // URL base de la API
  // Lista de fuentes de noticias conocidas
  static final List<String> _fuentes = [
    'TechCrunch',
    'Medium',
    'Dev.to',
    'Flutter Weekly',
    'TechRadar',
    'Hacker News',
    'Reddit',
    'Smashing Magazine',
    'Google Blog',
    'Flutter Community',
    'GitHub',
  ];

  // // Método para obtener las noticias iniciales
  // List<Noticia> getInitialNoticias() {
  //   return List.unmodifiable(_initialNoticias); // Devuelve una copia inmutable
  // }

  Future<List<Noticia>> getInitialNoticias() async {
    const String url =
        '${Constants.newUrl}?category=technology&apikey=${Constants.apiKey}&lang=es&max=15';

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['articles'];
        return data.map((json) => Noticia.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error al consultar las noticias: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al realizar la solicitud: $e');
    }
  }

  Future<List<Noticia>> fetchNoticiasFromApi(
    int pageNumber,
    int pageSize,
  ) async {
    final String url = '$_baseUrl?page=$pageNumber&pageSize=$pageSize';

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print('Datos devueltos por la API: ${response.data}');
        if (data.isEmpty) {
          return []; // Si no hay datos, devuelve una lista vacía
        }
        final noticias = data.map((json) => Noticia.fromJson(json)).toList();
        print('Noticias mapeadas al modelo: ${noticias.length}');
        return noticias;
      } else if (response.statusCode != null &&
          response.statusCode! >= 400 &&
          response.statusCode! < 500) {
        // Manejo específico para errores 4xx
        throw Exception(
          'Error 4xx al obtener las noticias: ${response.statusCode} - ${response.statusMessage}',
        );
      } else {
        throw Exception(
          'Error al obtener las noticias: ${response.statusCode} - ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw Exception('Error al realizar la solicitud: $e');
    }
  }

  // Future<List<Noticia>> fetchNoticiasFromApi(
  //   int pageNumber,
  //   int pageSize,
  // ) async {
  //   final String url = '$_baseUrl?page=$pageNumber&pageSize=$pageSize';

  //   try {
  //     final response = await _dio.get(url);

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = response.data;
  //       print('Datos devueltos por la API: ${response.data}');
  //       if (data.isEmpty) {
  //         return []; // Si no hay datos, devuelve una lista vacía
  //       }
  //       final noticias = data.map((json) => Noticia.fromJson(json)).toList();
  //     print('Noticias mapeadas al modelo: ${noticias.length}');
  //     return noticias;
  //     } else {
  //       throw Exception(
  //         'Error al obtener las noticias: ${response.statusCode}',
  //       );
  //     }
  //   } catch (e) {
  //     throw Exception('Error al realizar la solicitud: $e');
  //   }
  // }

  Future<void> createNoticia(Noticia noticia) async {
    try {
      final response = await _dio.post(
        _baseUrl,
        data: {
          "titulo": noticia.titulo,
          "descripcion": noticia.descripcion,
          "fuente": noticia.fuente,
          "publicadaEl": noticia.publicadaEl.toIso8601String(),
          "urlImagen": noticia.imageUrl,
        },
      );

      if (response.statusCode != 201) {
        throw Exception('Error al crear la noticia: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al crear la noticia: $e');
    }
  }

  Future<void> updateNoticia(Noticia noticia) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/${noticia.id}', // URL con el ID de la noticia
        data: {
          "titulo": noticia.titulo,
          "descripcion": noticia.descripcion,
          "fuente": noticia.fuente,
          "publicadaEl": noticia.publicadaEl.toIso8601String(),
          "urlImagen": noticia.imageUrl,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Error al actualizar la noticia: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al actualizar la noticia: $e');
    }
  }

  Future<void> deleteNoticia(String id) async {
  try {
    final response = await _dio.delete('$_baseUrl/$id'); // URL con el ID de la noticia

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar la noticia: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error al eliminar la noticia: $e');
  }
}
  // Future<List<Noticia>> fetchNoticiasFromApi(
  //   int pageNumber,
  //   int pageSize,
  // ) async {
  //   final String url =
  //       '${Constants.newUrl}?country=us&lang=es&page=$pageNumber&max=$pageSize';
  //       //'${Constants.newUrl}?country=us&lang=es&apikey=${Constants.apiKey}';

  //   try {
  //     final response = await _dio.get(
  //       url,
  //       options: Options(
  //         headers: {
  //           'X-Api-Key': Constants.apiKey, // Agrega el header X-Api-Key
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       final List<dynamic>? data = response.data['articles'];
  //       if (data == null || data.isEmpty) {
  //         throw Exception(
  //           '${Constants.mensajeError}: No se encontraron artículos.',
  //         );
  //       }
  //       return data.map((json) => Noticia.fromJson(json)).toList();
  //     } else {
  //       throw Exception(
  //         '${Constants.mensajeError}: Código de estado ${response.statusCode}',
  //       );
  //     }
  //   } catch (e) {
  //     throw Exception('${Constants.mensajeError}: $e');
  //   }
  // }
}
