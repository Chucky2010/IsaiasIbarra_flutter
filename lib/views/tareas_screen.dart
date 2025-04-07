import 'package:flutter/material.dart';
import 'package:mi_proyecto/views/login_screen.dart';
import 'package:mi_proyecto/views/welcom_screen.dart';


class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final List<Map<String, dynamic>> tareas = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _selectedIndex = 0; // Índice del elemento seleccionado en el navbar

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
  //final List<Map<String, String>> tareas = []; // Lista de tareas

  /*void _agregarTarea(String titulo, String detalle) {
    setState(() {
      tareas.add({'titulo': titulo, 'detalle': detalle});
    });
  }

  void _editarTarea(int index, String titulo, String detalle) {
    setState(() {
      tareas[index] = {'titulo': titulo, 'detalle': detalle};
    });
  }
*/
  void _agregarTarea(String titulo, String detalle, DateTime fecha) {
    setState(() {
      tareas.add({'titulo': titulo, 'detalle': detalle, 'fecha': fecha});
    });
  }

  void _editarTarea(int index, String titulo, String detalle, DateTime fecha) {
    setState(() {
      tareas[index] = {'titulo': titulo, 'detalle': detalle, 'fecha': fecha};
    });
  }

  void _mostrarModalAgregarTarea({int? index}) {
    final TextEditingController tituloController = TextEditingController(
      text: index != null ? tareas[index]['titulo'] : '',
    );
    final TextEditingController detalleController = TextEditingController(
      text: index != null ? tareas[index]['detalle'] : '',
    );
    final TextEditingController fechaController = TextEditingController(
      text:
          index != null
              ? (tareas[index]['fecha'] as DateTime).toLocal().toString().split(
                ' ',
              )[0]
              : '',
    );
    DateTime? fechaSeleccionada = index != null ? tareas[index]['fecha'] : null;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(index == null ? 'Agregar Tarea' : 'Editar Tarea'),
          key: _formKey,
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el modal sin guardar
              },
              child: const Text('Cancelar'),
            ),
           /* ElevatedButton(
              onPressed: () {
                final titulo = tituloController.text.trim();
                final detalle = detalleController.text.trim();
                final fecha = fechaController.text.trim();

                if (titulo.isNotEmpty && detalle.isNotEmpty) {
                  if (index == null) {
                    _agregarTarea(titulo, detalle, fechaSeleccionada!);
                  } else {
                    _editarTarea(index, titulo, detalle, fechaSeleccionada!);
                  }
                  Navigator.pop(context); // Cierra el modal y guarda la tarea
                }
              },
              child: const Text('Guardar'),
            ),*/
            // prueba alerta
              ElevatedButton(
            onPressed: () {
              // Validación manual
              final titulo = tituloController.text.trim();
              final detalle = detalleController.text.trim();
              final fecha = fechaController.text.trim();

              if (titulo.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('El título no puede estar vacío')),
                );
                return;
              }

              if (detalle.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('El detalle no puede estar vacío')),
                );
                return;
              }

              if (fecha.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Debe seleccionar una fecha')),
                );
                return;
              }

              if (index == null) {
                _agregarTarea(titulo, detalle, fechaSeleccionada!);
              } else {
                _editarTarea(index, titulo, detalle, fechaSeleccionada!);
              }
              Navigator.pop(context); // Cierra el modal y guarda la tarea
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
      appBar: AppBar(title: const Text('Tareas')),
      body:
          tareas.isEmpty
              ? const Center(
                child: Text(
                  'No hay tareas. Agrega una nueva tarea.',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                itemCount: tareas.length,
                itemBuilder: (context, index) {
                  final tarea = tareas[index];
                  return ListTile(
                    title: Text(tarea['titulo']!),
                    /*
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tarea['detalle']),
                        Text(
                          tarea['fecha'] != null
                              ? (tarea['fecha'] as DateTime)
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]
                              : 'Sin fecha',
                          style: const TextStyle(
                            color: Colors.grey,
                          ), // Estilo para la fecha
                        ),
                      ],
                    ),*/
                    onTap: () {
                      _mostrarModalAgregarTarea(
                        index: index,
                      ); // Editar tarea al tocar
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _mostrarModalAgregarTarea(index: index); // Editar tarea
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarModalAgregarTarea(),
        tooltip: 'Agregar Tarea',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Índice del elemento seleccionado
        onTap: _onItemTapped, // Maneja el evento de selección
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Añadir Tarea'),
          BottomNavigationBarItem(icon: Icon(Icons.close), label: "Salir"),
        ],
      ),
    );
  }
}