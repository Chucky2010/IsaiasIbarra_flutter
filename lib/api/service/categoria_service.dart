import 'package:mi_proyecto/api/service/base_service.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/domain/categoria.dart';

class CategoriaService extends BaseService {
  /// Obtiene todas las categorías desde la API
  Future<List<Categoria>> obtenerCategorias() async {
    final List<dynamic> categoriasJson = await get<List<dynamic>>(
      ApiConstantes.categoriaEndpoint,
      errorMessage: CategoriaConstantes.mensajeError,
    );

    return categoriasJson
        .map<Categoria>(
          (json) => CategoriaMapper.fromMap(json as Map<String, dynamic>),
        )
        .toList();
  }

  /// Crea una nueva categoría en la API
  /// Retorna el objeto categoria con los datos actualizados desde el servidor (incluyendo ID)
  Future<Categoria> crearCategoria(Categoria categoria) async {
    final response = await post(
      ApiConstantes.categoriaEndpoint,
      data: categoria.toMap(),
      errorMessage: CategoriaConstantes.errorCreated,
    );
    return CategoriaMapper.fromMap(response);
  }

  /// Edita una categoría existente en la API
  Future<Categoria> editarCategoria(Categoria categoria) async {
    final url = '${ApiConstantes.categoriaEndpoint}/${categoria.id}';
    final response = await put(
      url,
      data: categoria.toMap(),
      errorMessage: CategoriaConstantes.errorUpdated,
    );
    return CategoriaMapper.fromMap(response);
  }

  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    final url = '${ApiConstantes.categoriaEndpoint}/$id';
    await delete(url, errorMessage: CategoriaConstantes.errorDelete);
  }
}
