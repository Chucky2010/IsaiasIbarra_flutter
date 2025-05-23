import 'package:mi_proyecto/api/service/base_service.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/domain/noticia.dart';

class NoticiaService extends BaseService {
  /// Obtiene todas las noticias desde la API
  Future<List<Noticia>> obtenerNoticias() async {
    final List<dynamic> noticiasJson = await get<List<dynamic>>(
      ApiConstantes.noticiasEndpoint,
      errorMessage: NoticiasConstantes.mensajeError,
    );

    return noticiasJson
        .map<Noticia>(
          (json) => NoticiaMapper.fromMap(json as Map<String, dynamic>),
        )
        .toList();
  }

  /// Crea una nueva noticia en la API
  Future<Noticia> crearNoticia(Noticia noticia) async {
    final response = await post(
      ApiConstantes.noticiasEndpoint,
      data: noticia.toMap(),
      errorMessage: NoticiasConstantes.errorCreated,
    );
    return NoticiaMapper.fromMap(response);
  }

  /// Edita una noticia existente en la API
  Future<Noticia> editarNoticia(Noticia noticia) async {
    final url = '${ApiConstantes.noticiasEndpoint}/${noticia.id}';
    final response = await put(
      url,
      data: noticia.toMap(),
      errorMessage: NoticiasConstantes.errorUpdated,
    );
    return NoticiaMapper.fromMap(response);
  }

  /// Elimina una noticia existente en la API
  Future<void> eliminarNoticia(String id) async {
    final url = '${ApiConstantes.noticiasEndpoint}/$id';
    await delete(url, errorMessage: NoticiasConstantes.errorDelete);
  }
}
