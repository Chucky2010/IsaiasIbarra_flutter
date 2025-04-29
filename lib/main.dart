import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kgaona/bloc/contador/contador_bloc.dart';
import 'package:kgaona/views/login_screen.dart'; 

void main() async {
  await dotenv.load(fileName: ".env"); // Carga el archivo .env
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContadorBloc>(
          create: (context) => ContadorBloc(),
        ),
        // Otros BLoCs aquí...
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        ),
        home: LoginScreen(),
      ),
    );
  }
}
