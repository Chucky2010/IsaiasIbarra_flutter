import 'package:flutter/material.dart';
import 'package:mi_proyecto/views/login_screen.dart';
import 'package:mi_proyecto/views/welcom_screen.dart';
import 'package:mi_proyecto/api/service/tareas_service.dart';
import 'package:mi_proyecto/data/task_repository.dart';
import 'package:mi_proyecto/domain/task.dart';
import 'package:mi_proyecto/constants.dart';
import 'package:mi_proyecto/helpers/task_card_helper.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  late List<Task> _tareas = [];
  final TaskRepository taskRepository =
      TaskRepository(); // Instancia del repositorio
  final TareasService _tareasService = TareasService();
  final ScrollController _scrollController = ScrollController();
  //  bool _cargando = false;
  //  bool _hayMasTareas = true;
  //  int _paginaActual = 0;
  //  final int _limitePorPagina = 10;
  int _selectedIndex = 0; // Índice del elemento seleccionado en el navbar
  //  DateTime? fechaSeleccionada;
  //  final TextEditingController fechaController = TextEditingController();
  late int _nextTaskId;
  bool _cargando = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

      // Lógica para manejar la navegación según el índice seleccionado
      switch (index) {
        case 0: // Inicio
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
          break;
        case 1: // Añadir Tarea
          // Ya estás en TareasScreen, no necesitas navegar
          break;
        case 2: // Salir
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
          break;
      }
    }

    @override
    void initState() {
      super.initState();
      _tareas = _tareasService.obtenerTareas();
      _scrollController.addListener(_detectarScrollFinal);
      _nextTaskId =
          _tareasService.obtenerTareas().length +
          1; // Inicializa el ID de la siguiente tarea
    }

    @override
    void dispose() {
      _scrollController.dispose();
      super.dispose();
    }

    void _mostrarError(String mensaje) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensaje)));
    }

    Future<void> _obtenerTareas() async {
      try {
        final tareas = await _tareasService.obtenerTareas();
        setState(() {
          _tareas = tareas;
        });
      } catch (e) {
        _mostrarError('Error al cargar tareas: $e');
      }
    }

    // Future<void> _obtenerMasTareas() async {
    //   if (_cargando) return;

    //   setState(() {
    //     _cargando = true;
    //   });

    //   try {
    //     // Simulamos carga de 5 tareas nuevas
    //     await Future.delayed(const Duration(seconds: 1));

    //     final nuevasTareas = List.generate(5, (index) {
    //       return Task(
    //         title: 'Tarea ${_nextTaskId + index}',
    //         type: (index % 2) == 0 ? 'normal' : 'urgente',
    //         descripcion: 'Descripción de tarea ${_nextTaskId + index}',
    //         fecha: DateTime.now().add(Duration(days: index)),
    //       );
    //     });

    //     setState(() {
    //       _tareas.addAll(nuevasTareas);
    //       _nextTaskId += 5;
    //     });
    //   } catch (e) {
    //     _mostrarError('Error al cargar más tareas: $e');
    //   } finally {
    //     setState(() {
    //       _cargando = false;
    //     });
    //   }
    // }
    void _obtenerMasTareas() async {
      setState(() {
        _cargando = true;
      });

      // Simulamos carga de 5 tareas nuevas
      await Future.delayed(const Duration(seconds: 1));

      final nuevasTareas = _tareasService.obtenerMasTareas(_nextTaskId, 10);

      setState(() {
        _tareas.addAll(nuevasTareas);
        _nextTaskId = nuevasTareas.length;
        _cargando = false;
      });
    }

    void _detectarScrollFinal() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_cargando) {
        _obtenerMasTareas();
      }
    }

    // Future<void> _agregarTarea(Task tarea) async {
    //   try {
    //     await _tareasService.agregarTarea(tarea);
    //     setState(() {
    //       _tareas.add(tarea);
    //     });
    //   } catch (e) {
    //     _mostrarError('Error al agregar tarea: $e');
    //     await _obtenerTareas();
    //   }
    // }

    void _eliminarTarea(int index) async {
      // try {
      //   await _tareasService.eliminarTarea(index);
      setState(() {
        _tareas.removeAt(index);
      });
      // } catch (e) {
      //   _mostrarError('Error al eliminar tarea: $e');
      //   await _obtenerTareas();
      // }
    }

    // Future<void> _modificarTarea(int index, Task tarea) async {
    //   try {
    //     await _tareasService.modificarTarea(index, tarea);
    //     setState(() {
    //       _tareas[index] = tarea;
    //     });
    //   } catch (e) {
    //     _mostrarError('Error al modificar tarea: $e');
    //     await _obtenerTareas();
    //   }
    // }

    void _mostrarModalAgregarTarea({int? index}) async {
      final task = index != null ? _tareas[index] : null;

      final TextEditingController tituloController = TextEditingController(
        text: task?.title ?? '',
      );
      final TextEditingController detalleController = TextEditingController(
        text: task?.descripcion ?? '',
      );
      final TextEditingController fechaController = TextEditingController(
        text: task?.fecha.toLocal().toString().split(' ')[0] ?? '',
      );
      DateTime? fechaSeleccionada = task?.fecha;

      final TextEditingController tipoController = TextEditingController(
        text: task?.type ?? 'normal',
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(index == null ? 'Agregar Tarea' : 'Editar Tarea'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: detalleController,
                  decoration: const InputDecoration(
                    labelText: 'Detalle',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: fechaController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                    border: OutlineInputBorder(),
                    hintText: 'Seleccionar Fecha',
                  ),
                  onTap: () async {
                    DateTime? nuevaFecha = await showDatePicker(
                      context: context,
                      initialDate: fechaSeleccionada ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (nuevaFecha != null) {
                      setState(() {
                        fechaSeleccionada = nuevaFecha;
                        fechaController.text =
                            nuevaFecha.toLocal().toString().split(' ')[0];
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value:
                      tipoController.text.isEmpty ||
                              tipoController.text.toLowerCase() == 'normal'
                          ? 'normal'
                          : 'urgente',

                  decoration: const InputDecoration(
                    labelText: 'Tipo de Tarea',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'normal',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Normal'),
                        ],
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'urgente',
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Urgente'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        tipoController.text = newValue;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el modal sin guardar
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final titulo = tituloController.text.trim();
                  final detalle = detalleController.text.trim();
                  final fecha = fechaController.text.trim();
                  final tipo = tipoController.text.toUpperCase();

                  if (titulo.isEmpty ||
                      detalle.isEmpty ||
                      fecha.isEmpty ||
                      tipo.isEmpty) {
                    // Mostrar mensaje de error si algún campo está vacío
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Todos los campos son obligatorios'),
                      ),
                    );
                    return;
                  }

                  final tarea = Task(
                    title: titulo,
                    type: tipo,
                    fecha: fechaSeleccionada!,
                    descripcion: detalle,
                    fechalimite: DateTime.now().add(const Duration(days: 1)),
                  );

                  if (index == null) {
                    _tareasService.agregarTarea(tarea);
                  } else {
                    _tareasService.modificarTarea(index, tarea);
                  }
                  setState(() {
                    _tareas =
                        _tareasService
                            .obtenerTareas(); // Actualiza la lista de tareas
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    }

    void _mostrarTarjetaDeportiva(Task task, int index) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: TaskCardHelper.buildSportsCard(task, index), // Llama al método buildSportsCard
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el modal
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text(TITLE_APPBAR),
          backgroundColor: Colors.blueAccent,
        ),
        body: _tareas.isEmpty
            ? const Center(child: Text(EMPTY_LIST))
            : ListView.builder(
                controller: _scrollController,
                itemCount: _tareas.length + 1, // +1 para el indicador de carga
                itemBuilder: (context, index) {
                  if (index == _tareas.length) {
                    return _cargando
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : const SizedBox();
                  }

                  final task = _tareas[index];
                  return Column(
                    children: [
                      TaskCardHelper.buildTaskCard(
                        task,
                        onEdit: () => _mostrarModalAgregarTarea(index: index),
                        onDelete: () => _eliminarTarea(index),
                      ),
                      // Botón para visualizar el buildSportsCard
                      TextButton(
                        onPressed: () => _mostrarTarjetaDeportiva(task, index),
                        child: const Text(
                          'Ver Tarjeta Deportiva',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'agregar_tarea',
          onPressed: () => _mostrarModalAgregarTarea(),
          child: const Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, // Índice del elemento seleccionado
          onTap: _onItemTapped, // Maneja el evento de selección
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Añadir Tarea',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.close), label: "Salir"),
          ],
        ),
      );
    }
  }

