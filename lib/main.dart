import 'package:flutter/material.dart';
import 'views/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo ISAIAS Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('You have pushed the button this many times:'),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20), // Espaciado entre widgets
          Text(
            _counter > 0
                ? 'Contador en positivo'
                : _counter == 0
                    ? 'Contador en cero'
                    : 'Contador en negativo',
            style: TextStyle(
              fontSize: 18,
              color: _counter > 0
                  ? Colors.green
                  : _counter == 0
                      ? Colors.black
                      : Colors.red,
            ),
          ),
          const SizedBox(height: 20), // Espaciado entre widgets
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Advertencia'),
                    content: const Text('Esta es una advertencia importante.'),
                    actions: <Widget>[
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
            },
            child: const Text('Mostrar Advertencia'),
          ),
          const SizedBox(height: 20), // Espaciado entre botones
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Ir a Inicio de Sesión'),
          ),
        ],
      ),
    ),
    floatingActionButton: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        const SizedBox(width: 10), // Espaciado entre los botones
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _counter--; // Decrementa el contador
            });
          },
          tooltip: 'Decrement',
          child: const Icon(Icons.remove),
        ),
         const SizedBox(width: 10), // Espaciado entre los botones
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _counter = 0; // Reinicia el contador a 0
            });
          },
          tooltip: 'Reset',
          child: const Icon(Icons.refresh),
        ),
      ],
    ),
  );
}

}
