import 'package:flutter/material.dart';
import 'package:mi_proyecto/views/login_screen.dart';
import 'package:mi_proyecto/views/welcom_screen.dart';
import 'package:mi_proyecto/api/service/tareas_service.dart';


class TareasScreen extends StatefulWidget {
   const TareasScreen({super.key});
 
   @override
   _TareasScreenState createState() => _TareasScreenState();
 }
 
 class _TareasScreenState extends State<TareasScreen> {
   final List<Map<String, dynamic>> _tareas = [];
 
   final TareasService _tareasService = TareasService();
   final ScrollController _scrollController = ScrollController();
   bool _cargando = false;
   bool _hayMasTareas = true;
   int _paginaActual = 0;
   final int _limitePorPagina = 10;
   int _selectedIndex = 0; // Índice del elemento seleccionado en el navbar
   DateTime? fechaSeleccionada;
   final TextEditingController fechaController = TextEditingController();
 
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
     _cargarTareas();
     _scrollController.addListener(_detectarScrollFinal);
   }
 
   @override
   void dispose() {
     _scrollController.dispose();
     super.dispose();
   }
 
   Future<void> _cargarTareas() async {
     if (_cargando || !_hayMasTareas) return;
 
     setState(() {
       _cargando = true;
     });
   
 
     final nuevasTareas = await _tareasService.obtenerTareas(
       inicio: _paginaActual * _limitePorPagina,
       limite: _limitePorPagina,
     );
 
     setState(() {
       _tareas.addAll(nuevasTareas);
       _cargando = false;
       _hayMasTareas = nuevasTareas.length == _limitePorPagina;
       if (_hayMasTareas) _paginaActual++;
     });
   }
 
   void _detectarScrollFinal() {
     if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
         !_cargando) {
       _cargarTareas();
     }
   }
 
   Future<void> _agregarTarea(String titulo, String detalle, DateTime fecha) async {
     final nuevaTarea = {'titulo': titulo, 'detalle': detalle, 'fecha': fecha};
     await _tareasService.agregarTarea(nuevaTarea);
     setState(() {
       _tareas.insert(0, nuevaTarea); // Agrega la nueva tarea al inicio
     });
   }
 
   Future<void> _eliminarTarea(int index) async {
     await _tareasService.eliminarTarea(index);
     setState(() {
       _tareas.removeAt(index);
     });
   }
 
   void _mostrarModalAgregarTarea() {
     final TextEditingController tituloController = TextEditingController();
     final TextEditingController detalleController = TextEditingController();
 
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: const Text('Agregar Tarea'),
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
                 readOnly: true, // Hace que el campo no sea editable manualmente
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
                       fechaController.text = nuevaFecha.toLocal().toString().split(' ')[0];
                     });
                   }
                 },
               ),
             ],
           ),
           actions: [
             TextButton(
               onPressed: () {
                 Navigator.pop(context);
               },
               child: const Text('Cancelar'),
             ),

             ElevatedButton(
               onPressed: () {
                 final titulo = tituloController.text.trim();
                 final detalle = detalleController.text.trim();
                 final fecha = fechaController.text.trim();
 
                 if (titulo.isEmpty || detalle.isEmpty || fechaSeleccionada == null) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Todos los campos son obligatorios')),
                   );
                   return;
                 }

                 _agregarTarea(titulo, detalle, fechaSeleccionada!);
                  Navigator.pop(context);
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
       body: ListView.builder(
         controller: _scrollController,
         itemCount: _tareas.length + (_cargando ? 1 : 0),
         itemBuilder: (context, index) {
           if (index == _tareas.length) {
             return const Center(
               child: Padding(
                 padding: EdgeInsets.all(16.0),
                 child: CircularProgressIndicator(),
               ),
             );
           }
 
           final tarea = _tareas[index];
           return Dismissible(
             key: Key(tarea['titulo']),
             direction: DismissDirection.endToStart,
             background: Container(
               color: Colors.red,
               alignment: Alignment.centerRight,
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: const Icon(Icons.delete, color: Colors.white),
             ),
             onDismissed: (direction) {
               _eliminarTarea(index);
             },
             child: ListTile(
               title: Text(tarea['titulo']),
             
             ),
           );
         },
       ),
       floatingActionButton: FloatingActionButton(
         onPressed: _mostrarModalAgregarTarea,
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