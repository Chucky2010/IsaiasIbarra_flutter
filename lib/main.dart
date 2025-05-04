import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mi_proyecto/bloc/counter_bloc/counter_bloc.dart';
import 'package:mi_proyecto/bloc/counter_bloc/counter_event.dart';
import 'package:mi_proyecto/bloc/counter_bloc/counter_state.dart';
import 'package:mi_proyecto/di/locator.dart';
import 'package:mi_proyecto/views/login_screen.dart';


Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await initLocator();// Carga el archivo .env
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
       //home: const MyHomePage(title: 'ISAIAS flutter app'),
      home: BlocProvider(
        create: (context) => CounterBloc(),
        child: const MyHomePage(title: 'ISAIAS flutter app'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
          BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                return Text(
                  state.count.toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
          const SizedBox(height: 20), // Espaciado entre widgets
          BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                return Text(
                  state.count > 0
                      ? 'Contador en positivo'
                      : state.count == 0
                          ? 'Contador en cero'
                          : 'Contador en negativo',
                  style: TextStyle(
                    fontSize: 18,
                    color: state.count > 0
                        ? Colors.green
                        : state.count == 0
                            ? Colors.black
                            : Colors.red,
                  ),
                );
              },
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
          const SizedBox(height: 40), // Espaciado entre botones
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('INICIO DE SESION'),
          ),
            
        ],
      ),
    ),
    floatingActionButton: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'increment',
          onPressed: () {
              context.read<CounterBloc>().add(IncrementEvent());
            },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        const SizedBox(width: 10), // Espaciado entre los botones
        FloatingActionButton(
          heroTag: 'decrement',
          onPressed: () {
              context.read<CounterBloc>().add(DecrementEvent());
            },
          tooltip: 'Decrement',
          child: const Icon(Icons.remove),
        ),
         const SizedBox(width: 10), // Espaciado entre los botones
        FloatingActionButton(
          onPressed: () {
              context.read<CounterBloc>().add(ResetEvent());
            },
          heroTag: 'reset',
          tooltip: 'Reset',
          child: const Icon(Icons.refresh),
        ),
      ],
    ),
  );
}

}
