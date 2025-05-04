import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_bloc.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_event.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_state.dart';
import 'package:mi_proyecto/data/categoria_repository.dart';
import 'package:mi_proyecto/domain/categoria.dart';
import 'package:mi_proyecto/domain/noticia.dart';
import 'package:mi_proyecto/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';
import 'package:mi_proyecto/helpers/error_helper.dart';
import 'package:mi_proyecto/views/categoria_screen.dart';
import 'package:watch_it/watch_it.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});

  @override
  State<NoticiaScreen> createState() => _NoticiaScreenState();
}

class _NoticiaScreenState extends State<NoticiaScreen> {
  final NoticiaBloc _noticiaBloc = NoticiaBloc();
  final ScrollController _scrollController = ScrollController();
  final CategoriaRepository _categoriaRepository = CategoriaRepository();
  List<Categoria> _categorias = [];

  bool _ordenarPorFecha = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _fuenteController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noticiaBloc.add(NoticiaInitEvent());
    _loadCategorias();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final state = _noticiaBloc.state;
      if (state is NoticiaLoaded && state.hasMore) {
        _noticiaBloc.add(NoticiaLoadMoreEvent());
      }
    }
  }

  Future<void> _loadCategorias() async {
    try {
      final categorias = await _categoriaRepository.getCategorias();
      setState(() {
        _categorias = [
          Categoria(
            id: Constants.defaultcategoriaId,
            nombre: 'Sin categoría',
            descripcion: '',
            imagenUrl: '',
          ),
          ...categorias,
        ];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar las categorías: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tituloController.dispose();
    _descripcionController.dispose();
    _fuenteController.dispose();
    _imageUrlController.dispose();
    _fechaController.dispose();
    _noticiaBloc.close();
    super.dispose();
  }

  void _mostrarFormulario() {
    String? _categoriaSeleccionada;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _tituloController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El título es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La descripción es obligatoria';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _fuenteController,
                    decoration: const InputDecoration(labelText: 'Fuente'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La fuente es obligatoria';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL de la imagen',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La URL es obligatoria';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _fechaController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha Publicada',
                    ),
                    readOnly: true,
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        _fechaController.text = DateFormat(
                          Constants.formatoFecha,
                        ).format(pickedDate);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La fecha es obligatoria';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: _categoriaSeleccionada,
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    items:
                        _categorias
                            .map(
                              (categoria) => DropdownMenuItem(
                                value: categoria.id,
                                child: Text(categoria.nombre),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      _categoriaSeleccionada = value;
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _agregarNoticia(_categoriaSeleccionada);
                      }
                    },
                    child: const Text('Agregar Noticia'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _agregarNoticia(String? categoriaId) async {
    if (_formKey.currentState!.validate()) {
      final nuevaNoticia = Noticia(
        id: DateTime.now().toString(), // Genera un ID único
        titulo: _tituloController.text,
        descripcion: _descripcionController.text,
        fuente: _fuenteController.text,
        publicadaEl: DateFormat(
          Constants.formatoFecha,
        ).parse(_fechaController.text),
        imageUrl:
            _imageUrlController.text.isNotEmpty
                ? _imageUrlController.text
                : 'https://via.placeholder.com/150', // Imagen predeterminada
        categoriaId: categoriaId ?? Constants.defaultcategoriaId,
      );

      _noticiaBloc.add(NoticiaCreateEvent(nuevaNoticia));

      // Limpia los campos del formulario
      _tituloController.clear();
      _descripcionController.clear();
      _fuenteController.clear();
      _imageUrlController.clear();
      _fechaController.clear();

      if (mounted) {
        Navigator.pop(context);
      }
      
      _mostrarError('Noticia agregada correctamente', color: Colors.green);
    }
  }

  void _mostrarFormularioEditar(Noticia noticia, int index) {
    _tituloController.text = noticia.titulo;
    _descripcionController.text = noticia.descripcion;
    _fuenteController.text = noticia.fuente;
    _imageUrlController.text = noticia.imageUrl;
    _fechaController.text = DateFormat(
      Constants.formatoFecha,
    ).format(noticia.publicadaEl);
    
    String? categoriaSeleccionada =
        _categorias
            .firstWhere(
              (cat) => cat.id == noticia.categoriaId,
              orElse:
                  () => Categoria(
                    id: Constants.defaultcategoriaId,
                    nombre: 'Sin categoría',
                    descripcion: '',
                    imagenUrl: '',
                  ),
            )
            .id;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El título no puede estar vacío';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción no puede estar vacía';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _fuenteController,
                  decoration: const InputDecoration(labelText: 'Fuente'),
                ),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL de la imagen',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _fechaController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha Publicada',
                  ),
                  readOnly: true,
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      _fechaController.text = DateFormat(
                        Constants.formatoFecha,
                      ).format(pickedDate);
                    }
                  },
                ),

                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: categoriaSeleccionada,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  items: [
                    // Agrega una categoría predeterminada si no existe
                    if (!_categorias.any(
                      (categoria) =>
                          categoria.id == Constants.defaultcategoriaId,
                    ))
                      const DropdownMenuItem(
                        value: Constants.defaultcategoriaId,
                        child: Text('Sin categoría'),
                      ),
                    ..._categorias.map(
                      (categoria) => DropdownMenuItem(
                        value: categoria.id,
                        child: Text(categoria.nombre),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    categoriaSeleccionada = value;
                  },
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final noticiaEditada = Noticia(
                        id: noticia.id, // Mantiene el mismo ID
                        titulo: _tituloController.text,
                        descripcion: _descripcionController.text,
                        fuente: _fuenteController.text,
                        publicadaEl: DateFormat(Constants.formatoFecha).parse(
                          _fechaController.text,
                        ), // Mantiene la misma fecha
                        imageUrl:
                            _imageUrlController.text.isNotEmpty
                                ? _imageUrlController.text
                                : 'https://via.placeholder.com/150',
                        categoriaId: categoriaSeleccionada, //categoria seleccionada
                      );

                      _noticiaBloc.add(NoticiaUpdateEvent(noticiaEditada));

                      // Limpia los campos del formulario
                      _tituloController.clear();
                      _descripcionController.clear();
                      _fuenteController.clear();
                      _imageUrlController.clear();
                      _fechaController.clear();

                      Navigator.pop(context); // Cierra el modal
                      _mostrarError(
                        'Noticia actualizada correctamente',
                        color: Colors.green,
                      );
                    }
                  },
                  child: const Text('Guardar Cambios'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.tituloApp),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: 'Ir a Categorías',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoriaScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: Constants.tooltipOrden,
            onPressed: () {
              setState(() {
                _ordenarPorFecha = !_ordenarPorFecha;
              });
              _noticiaBloc.add(NoticiaRefreshEvent());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Disparamos el evento de refrescar noticias
          _noticiaBloc.add(NoticiaRefreshEvent());
          
          // Mostramos mensaje de actualización
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lista de noticias actualizada'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
          }

          // Esperamos un poco para que sea visible la animación de recarga
          return await Future.delayed(const Duration(milliseconds: 800));
        },
        child: Container(
          color: Colors.grey[200],
          child: BlocConsumer<NoticiaBloc, NoticiaState>(
            bloc: _noticiaBloc,
            listener: (context, state) {
              if (state is NoticiaError) {
                _mostrarErrorDesdeState(state);
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  if (state is NoticiaLoaded)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.update, color: Colors.grey, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Última actualización: ${DateFormat(Constants.formatoFecha).format(state.lastUpdated)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: _buildBody(state),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormulario,
        tooltip: 'Agregar Noticia',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(NoticiaState state) {
    if (state is NoticiaInitial || (state is NoticiaLoading && state is! NoticiaLoaded)) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NoticiaError && _noticiaBloc.state is! NoticiaLoaded) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            state.message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else if (state is NoticiaLoaded) {
      final noticias = state.noticias;
      if (noticias.isEmpty) {
        return const Center(
          child: Text(
            Constants.listaVacia,
            style: TextStyle(fontSize: 16),
          ),
        );
      }
      
      return ListView.builder(
        controller: _scrollController,
        itemCount: noticias.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == noticias.length) {
            return state.hasMore
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No hay más noticias para cargar.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  );
          }

          final noticia = noticias[index];
          final categoria = _categorias.firstWhere(
            (cat) => cat.id == noticia.categoriaId,
            orElse: () => Categoria(
              id: Constants.defaultcategoriaId,
              nombre: 'Sin categoría',
              descripcion: '',
              imagenUrl: '',
            ),
          );
          
          return Column(
            children: [
              Card(
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              26.0,
                              16.0,
                              16.0,
                              16.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  noticia.titulo,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  noticia.descripcion,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  noticia.fuente,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  DateFormat(
                                    Constants.formatoFecha,
                                  ).format(
                                    noticia.publicadaEl,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  categoria.nombre,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.network(
                                  noticia.imageUrl,
                                  height: 80,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  errorBuilder: (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.favorite_border),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.share),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    _mostrarFormularioEditar(noticia, index);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Confirmar eliminación'),
                                          content: const Text('¿Estás seguro de que deseas eliminar esta noticia?'),
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
                                      _noticiaBloc.add(NoticiaDeleteEvent(noticia.id));
                                      _mostrarError(
                                        'Noticia eliminada correctamente',
                                        color: Colors.green,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
    
    // Estado por defecto
    return const Center(
      child: Text('No hay información para mostrar'),
    );
  }

  void _mostrarError(String mensaje, {Color color = Colors.red}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: color,
        ),
      );
    }
  }

  void _mostrarErrorDesdeState(NoticiaError state) {
    final mensaje = state.message;
    Color color = Colors.red;
    
    if (state.statusCode != null) {
      final errorData = ErrorHelper.getErrorMessageAndColor(state.statusCode);
      _mostrarError(errorData['message'], color: errorData['color']);
    } else {
      _mostrarError(mensaje, color: color);
    }
  }
}
