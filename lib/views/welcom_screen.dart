import 'package:flutter/material.dart';

//import 'package:kgaona/views/tareasscreen.dart';
import 'package:mi_proyecto/views/login_screen.dart';
import 'package:mi_proyecto/main.dart';

import 'package:mi_proyecto/presentation/task_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  List<String> quotes = [];
  bool isLoading = false;

  Future<void> fetchQuotes() async {
    setState(() {
      isLoading = true;
    });

    // Simulación de una llamada a una API o base de datos
    await Future.delayed(const Duration(seconds: 2)); // Simula un retraso
    setState(() {
      quotes = [
        'Cotización 1: 100',
        'Cotización 2: 200',
        'Cotización 3: 300',
        'Cotización 4: 400',
      ];
      isLoading = false;
    });
  }

  void _mostrarCotizaciones() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cotizaciones'),
          content: SingleChildScrollView(
            child: Column(
              children:
                  quotes.map((quote) => ListTile(title: Text(quote))).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  int _selectedIndex = 0;

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TareasScreen()),
        );

        break;
      case 2: // Salir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      drawer:  Drawer(
        child:  ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text(
                'Menú de Navegación',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Tareas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TareasScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Contador'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage(title: '',)),
                );
              },
              
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Salir'),
              onTap: () {
                // Cierra la aplicación
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Confirmar'),
                      content:const  Text('¿Estás seguro de que deseas salir?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                          },
                          child: const Text('Cancelar'),
                        ),
               
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            ); // Redirige al login
                          },
                          child: const Text('Salir'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),

      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(
              '¡Bienvenido!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 16),
             Text(
              'Has iniciado sesión exitosamente.',
              style: TextStyle(fontSize: 18),
            ),
             SizedBox(height: 16),
            //ElevatedButton(
              // onPressed: () {
              //   // Acción para listar cotizaciones
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(content: Text('Listando cotizaciones...')),
              //   );
              // },
            //   child: const Text('Listar Cotizaciones PS'),
        
            // ),
            // ElevatedButton(
            //   onPressed: fetchQuotes,
            //   child: const Text('Listar Cotizaciones'),
            // ),
            // const SizedBox(height: 16),
            // if (isLoading)
            //   const CircularProgressIndicator()
            // else
            //   ...quotes.map((quote) => Text(quote)),
            // ElevatedButton(
            //   onPressed: _mostrarCotizaciones,
            //   child: const Text("Cotizaciones"),
            // ),
            // const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     // Aquí puedes agregar la lógica para listar cotizaciones
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text('Listando cotizaciones...')),
            //     );
            //   },
            //   child: const Text('Listar Cotizaciones'),
            // ),
            // const SizedBox(height: 40),
          //   ElevatedButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const TareasScreen()),
          //     );
          //   },
          //   child: const Text('LISTA DE TAREAS'),
          // ),
          ],
        ),
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