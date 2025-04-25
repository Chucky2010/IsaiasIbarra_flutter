import 'package:flutter/material.dart';
import 'package:mi_proyecto/api/services/categoria_service.dart';
import 'package:mi_proyecto/domain/categoria.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';
import 'package:mi_proyecto/helpers/error_helper.dart';

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({Key? key}) : super(key: key);

  @override
  _CategoriaScreenState createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  final CategoriaService _categoriaService = CategoriaService();
  List<Categoria> categorias = [];
  bool isLoading = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final fetchedCategorias = await _categoriaService.getCategorias();
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

        await _categoriaService.crearCategoria(
          nuevaCategoria,
        ); // Llama al servicio
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
              : categorias.isEmpty
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
                    trailing: Row(mainAxisSize: MainAxisSize.min),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarCategoria,
        tooltip: 'Agregar Categoría',
        child: const Icon(Icons.add),
      ),
    );
  }
}
