import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/categoria/categoria_bloc.dart';
import 'package:mi_proyecto/bloc/categoria/categoria_event.dart';
import 'package:mi_proyecto/bloc/categoria/categoria_state.dart';
import 'package:mi_proyecto/data/categoria_repository.dart';
import 'package:mi_proyecto/domain/categoria.dart';
import 'package:mi_proyecto/helpers/error_helper.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

class CategoriaScreen extends StatelessWidget {
  const CategoriaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoriaBloc(
        categoriaRepository: CategoriaRepository(),
      )..add(LoadCategoriasEvent()),
      child: const CategoriaView(),
    );
  }
}

class CategoriaView extends StatefulWidget {
  const CategoriaView({Key? key}) : super(key: key);

  @override
  _CategoriaViewState createState() => _CategoriaViewState();
}

class _CategoriaViewState extends State<CategoriaView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: BlocConsumer<CategoriaBloc, CategoriaState>(
        listener: (context, state) {
          if (state is CategoriaErrorState) {
            // Usamos ErrorHelper para obtener el mensaje y color apropiados
            // Asumimos que el mensaje de error podría contener un código de estado
            final errorData = _parseErrorMessage(state.message);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorData['message']),
                backgroundColor: errorData['color'],
              ),
            );
          } else if (state is CategoriaActionSuccess) {
            // Mostramos un SnackBar para las acciones exitosas
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CategoriaLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoriaErrorState) {
            final errorData = _parseErrorMessage(state.message);
            return Center(
              child: Text(
                errorData['message'],
                style: TextStyle(color: errorData['color'], fontSize: 16),
              ),
            );
          } else if (state is CategoriaLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CategoriaBloc>().add(RefreshCategoriasEvent());
              },
              child: Column(
                children: [
                  _buildUltimaActualizacion(state.ultimaActualizacion),
                  Expanded(
                    child: state.categorias.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay categorías disponibles.',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: state.categorias.length,
                            itemBuilder: (context, index) {
                              final categoria = state.categorias[index];
                              return ListTile(
                                title: Text(categoria.nombre),
                                subtitle: Text('ID: ${categoria.id}'),
                                leading: const Icon(Icons.category),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _mostrarDialogoEditar(context, categoria),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _mostrarDialogoEliminar(context, categoria),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No hay categorías disponibles.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoAgregar(context),
        tooltip: 'Agregar Categoría',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Método para interpretar el mensaje de error y obtener un código de estado si existe
  Map<String, dynamic> _parseErrorMessage(String errorMessage) {
    // Intentamos encontrar un código de estado en el mensaje
    final RegExp regExp = RegExp(r'(\d{3})');
    final match = regExp.firstMatch(errorMessage);
    
    if (match != null) {
      final statusCode = int.tryParse(match.group(1) ?? '');
      if (statusCode != null) {
        return ErrorHelper.getErrorMessageAndColor(statusCode);
      }
    }
    
    // Si no encontramos un código de estado, usamos el mensaje original
    return {
      'message': errorMessage,
      'color': Colors.red,
    };
  }

  Widget _buildUltimaActualizacion(DateTime? ultimaActualizacion) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.update, color: Colors.grey, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              ultimaActualizacion != null
                  ? 'Última actualización: ${_formatDateTime(ultimaActualizacion)}'
                  : 'No se ha actualizado recientemente.',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Método auxiliar para formatear la fecha y hora de manera más compacta
  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    return '${local.day}/${local.month}/${local.year} ${local.hour}:${local.minute.toString().padLeft(2, '0')}';
  }

  void _mostrarDialogoAgregar(BuildContext context) async {
    final TextEditingController nombreController = TextEditingController();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Categoría'),
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

    if (result != null) {
      final nuevaCategoria = Categoria(
        id: '', // El ID será generado por la API
        nombre: result['nombre'],
        descripcion: '',
        imagenUrl: '',
      );
      
      context.read<CategoriaBloc>().add(AddCategoriaEvent(nuevaCategoria));
    }
  }

  void _mostrarDialogoEditar(BuildContext context, Categoria categoria) async {
    final TextEditingController nombreController = TextEditingController(
      text: categoria.nombre,
    );

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Categoría'),
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

    if (result != null) {
      final categoriaEditada = Categoria(
        id: categoria.id,
        nombre: result['nombre'],
        descripcion: categoria.descripcion,
        imagenUrl: categoria.imagenUrl,
      );
      
      context.read<CategoriaBloc>().add(UpdateCategoriaEvent(categoria.id, categoriaEditada));
    }
  }

  void _mostrarDialogoEliminar(BuildContext context, Categoria categoria) async {
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
      (context).read<CategoriaBloc>().add(DeleteCategoriaEvent(categoria.id));
    }
  }
}
