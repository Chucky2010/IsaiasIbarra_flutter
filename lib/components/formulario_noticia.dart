import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/domain/categoria.dart';
import 'package:mi_proyecto/domain/noticia.dart';

class FormularioNoticia extends StatefulWidget {
  final Noticia? noticia; // Noticia existente para edición (null para creación)
  final List<Categoria> categorias; // Lista de categorías disponibles

  const FormularioNoticia({super.key, this.noticia, required this.categorias});

  @override
  State<FormularioNoticia> createState() => _FormularioNoticiaState();
}

class _FormularioNoticiaState extends State<FormularioNoticia> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  late TextEditingController _fuenteController;
  late TextEditingController _imagenUrlController;
  late TextEditingController _fechaController;
  DateTime _fechaSeleccionada = DateTime.now();
  String _selectedCategoriaId = CategoriaConstantes.defaultcategoriaId;
  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.noticia?.titulo ?? '');
    _descripcionController = TextEditingController(text: widget.noticia?.descripcion ?? '');
    _fuenteController = TextEditingController(text: widget.noticia?.fuente ?? '');
    _imagenUrlController = TextEditingController(text: widget.noticia?.urlImagen ?? '');
    _fechaSeleccionada = widget.noticia?.publicadaEl ?? DateTime.now();
    _fechaController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(_fechaSeleccionada)
    );
    
    // Verificar si el ID de categoría existe en la lista antes de asignarlo
    if (widget.noticia?.categoriaId != null) {
      final existeCategoria = widget.categorias.any((c) => c.id == widget.noticia!.categoriaId);
      _selectedCategoriaId = existeCategoria 
          ? widget.noticia!.categoriaId! 
          :CategoriaConstantes.defaultcategoriaId;
    } else {
      _selectedCategoriaId = CategoriaConstantes.defaultcategoriaId;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _fuenteController.dispose();
    _imagenUrlController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    if (!context.mounted) return;
    
    try {
      final DateTime? fechaSeleccionada = await showDatePicker(
        context: context,
        initialDate: _fechaSeleccionada,
        firstDate: DateTime(2000),
        lastDate: DateTime.now().add(const Duration(days: 1)),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (fechaSeleccionada != null) {
        setState(() {
          _fechaSeleccionada = fechaSeleccionada;
          _fechaController.text = DateFormat('dd/MM/yyyy').format(fechaSeleccionada);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al seleccionar fecha: $e")),
        );
      }
    }
  }

  void _guardarNoticia() {
    if (_formKey.currentState!.validate()) {
      final noticia = Noticia(
        id: widget.noticia?.id,
        titulo: _tituloController.text,
        descripcion: _descripcionController.text,
        fuente: _fuenteController.text,
        publicadaEl: _fechaSeleccionada,
        urlImagen: _imagenUrlController.text.isEmpty 
            ? "https://picsum.photos/200/300" 
            : _imagenUrlController.text,
        categoriaId: _selectedCategoriaId,
      );
      Navigator.of(context).pop(noticia);
    }
  }

  @override
  Widget build(BuildContext context) {

    final bottomPadding = MediaQuery.of(context).viewInsets.bottom + 
                        MediaQuery.of(context).padding.bottom + 32;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: bottomPadding,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Text(
            //   widget.noticia == null ? 'Agregar Noticia' : 'Editar Noticia',
            //   style: const TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            //const SizedBox(height: 16),
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un título';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una descripción';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fuenteController,
              decoration: const InputDecoration(
                labelText: 'Fuente',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una fuente';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imagenUrlController,
              decoration: const InputDecoration(
                labelText: 'URL de la imagen',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la URL de una imagen';
                }
                // Podríamos validar que es una URL válida
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Campo de fecha
            TextFormField(
              controller: _fechaController,
              decoration: const InputDecoration(
                labelText: 'Fecha de publicación',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: _seleccionarFecha,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La fecha es requerida';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Selector de categoría
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              value: _selectedCategoriaId,
              items: [
                // Opción por defecto
                const DropdownMenuItem<String>(
                  value: CategoriaConstantes.defaultcategoriaId,
                  child: Text('Sin categoría'),
                ),                // Opciones de categorías cargadas
                ...widget.categorias
                    .where((categoria) => categoria.id != null && categoria.id!.isNotEmpty)
                    .map((categoria) {
                  return DropdownMenuItem<String>(
                    value: categoria.id!,
                    child: Text(categoria.nombre),
                  );
                }),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategoriaId = value;
                  });
                }
              },
            ),
            const SizedBox(height: 32),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: TextButton( // Cambiar a OutlinedButton para más claridad
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                      onPressed: _guardarNoticia,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        widget.noticia == null ? 'Agregar' : 'Guardar',
                      ),
                    ),
                  ),
                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}