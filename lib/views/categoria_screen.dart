import 'package:flutter/material.dart';
import 'package:mi_proyecto/data/categoria_repository.dart';
import 'package:mi_proyecto/domain/categoria.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';
import 'package:mi_proyecto/helpers/error_helper.dart';

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({Key? key}) : super(key: key);

  @override
  _CategoriaScreenState createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  final CategoriaRepository _categoriaRepository = CategoriaRepository();
  List<Categoria> categorias = [];
  bool isLoading = false;
  bool hasError = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();
   int currentPage = 1;

  DateTime? _ultimaActualizacion;

  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    if (isLoading || !_hasMore) return;

    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final fetchedCategorias = await _categoriaRepository.getCategorias();
      setState(() {
        categorias = fetchedCategorias;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });

      String errorMessage = 'Error desconocido';
      Color errorColor = Colors.grey;

      if (e is ApiException) {
        final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode);
        errorMessage = errorData['message'];
        errorColor = errorData['color'];
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
      );
    }
  }

  Future<void> _agregarCategoria() async {
    final nuevaCategoriaData = await _mostrarDialogCategoria(context);
    if (nuevaCategoriaData != null) {
      try {
        // Crear un objeto Categoria a partir de los datos del diálogo
        final nuevaCategoria = Categoria(
          id: '', // El ID será generado por la API
          nombre: nuevaCategoriaData['nombre'],
          descripcion: '',
          imagenUrl: '',
        );

        await _categoriaRepository.crearCategoria(
          nuevaCategoria,// Llama al servicio
        ); 
        
        _loadCategorias(); // Recarga las categorías
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoría agregada exitosamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar la categoría: $e')),
        );
      }
    }
  }

  Future<void> _editarCategoria(Categoria categoria) async {
    final categoriaEditadaData = await _mostrarDialogCategoria(
      context,
      categoria: categoria,
    );

    if (categoriaEditadaData != null) {
      try {
        final categoriaEditada = Categoria(
          id: categoria.id, // Mantiene el mismo ID
          nombre: categoriaEditadaData['nombre'],
          descripcion: categoria.descripcion,
          imagenUrl: categoria.imagenUrl,
        );

        await _categoriaRepository.editarCategoria(
          categoria.id,
          categoriaEditada,
        );
        _loadCategorias(); // Recarga las categorías
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoría editada exitosamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al editar la categoría: $e')),
        );
      }
    }
  }

  Future<void> _eliminarCategoria(Categoria categoria) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
            '¿Estás seguro de que deseas eliminar la categoría "${categoria.nombre}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _categoriaRepository.eliminarCategoria(categoria.id);
        _loadCategorias(); // Recarga las categorías
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoría eliminada exitosamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar la categoría: $e')),
        );
      }
    }
  }

  Future<Map<String, dynamic>?> _mostrarDialogCategoria(
    BuildContext context, {
    Categoria? categoria,
  }) async {
    final TextEditingController nombreController = TextEditingController(
      text: categoria?.nombre ?? '',
    );

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            categoria == null ? 'Agregar Categoría' : 'Editar Categoría',
          ),
          content: TextField(
            controller: nombreController,
            decoration: const InputDecoration(
              labelText: 'Nombre de la Categoría',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nombreController.text.isNotEmpty) {
                  Navigator.pop(context, {'nombre': nombreController.text});
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('El nombre no puede estar vacío'),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshCategorias() async {
    setState(() {
      categorias.clear(); // Limpia la lista de noticias
      _hasMore = true; // Permite cargar más noticias
      hasError = false; // Reinicia el estado de error
    });

    await _loadCategorias(); // Recarga las noticias
    setState(() {
      _ultimaActualizacion =
          DateTime.now(); // Actualiza la fecha de la última actualización
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError
              ? const Center(
                child: Text(
                  'Ocurrió un error al cargar las categorías.',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
            : RefreshIndicator(
              onRefresh:() => _refreshCategorias(),
              child: Column(
                children: [
                  _buildUltimaActualizacion(), // Muestra la última actualización
                  Expanded(
              child: categorias.isEmpty
              ? const Center(
                child: Text(
                  'No hay categorías disponibles.',
                  style: TextStyle(fontSize: 16),
                ),
              )
              : ListView.builder(
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final categoria = categorias[index];
                  return ListTile(
                    title: Text(categoria.nombre),
                    subtitle: Text('ID: ${categoria.id}'),
                    leading: const Icon(Icons.category),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editarCategoria(categoria),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _eliminarCategoria(categoria),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarCategoria,
        tooltip: 'Agregar Categoría',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUltimaActualizacion() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.update, color: Colors.grey, size: 16),
        const SizedBox(width: 8),
        Text(
          _ultimaActualizacion != null
              ? 'Última actualización: ${_ultimaActualizacion!.toLocal()}'
              : 'No se ha actualizado recientemente.',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    ),
  );
}
}
