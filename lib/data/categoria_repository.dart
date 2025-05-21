import 'package:kgaona/api/service/categoria_service.dart';
import 'package:kgaona/core/base_repository.dart';
import 'package:kgaona/domain/categoria.dart';

class CategoriaRepository extends BaseRepository<Categoria> {
  final CategoriaService _categoriaService = CategoriaService();

  @override
  void validarEntidad(Categoria categoria) {
    validarNoVacio(categoria.nombre, 'nombre de la categoría');
    validarNoVacio(categoria.descripcion, 'descripción de la categoría');
    validarNoVacio(categoria.imagenUrl, 'URL de la imagen');
  }

  /// Obtiene todas las categorías desde el repositorio
  Future<List<Categoria>> obtenerCategorias() async {
    return manejarExcepcion(
      () => _categoriaService.obtenerCategorias(),
      mensajeError: 'Error al obtener categorías',
    );
  }

  /// Crea una nueva categoría
  Future<void> crearCategoria(Categoria categoria) async {
    return manejarExcepcion(() {
      validarEntidad(categoria);
      return _categoriaService.crearCategoria(categoria);
    }, mensajeError: 'Error al crear categoría');
  }

  /// Edita una categoría existente
  Future<void> actualizarCategoria(Categoria categoria) async {
    return manejarExcepcion(() {
      validarEntidad(categoria);
      return _categoriaService.editarCategoria(categoria);
    }, mensajeError: 'Error al actualizar categoría');
  }

  /// Elimina una categoría
  Future<void> eliminarCategoria(String id) async {
    return manejarExcepcion(() {
      validarId(id);
      return _categoriaService.eliminarCategoria(id);
    }, mensajeError: 'Error al eliminar categoría');
  }
}
