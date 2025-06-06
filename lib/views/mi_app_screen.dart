/*
¿Cómo controla el estado los cambios de color? ¿Qué hace Column en este layout?
Con una lista de colores y el setState() dentro de la funcion cambiarColor()> Se le suma 1 al indice actual y 
se obtiene el resto de la division con el tamaño de la lista de colores,el rersultado 
es el nuevo indice del color a mostrar. 
Column alinea a los widgets hijos uno detras de otro.
*/

import 'package:flutter/material.dart';
import 'package:mi_proyecto/components/custom_bottom_navigation_bar.dart';
import 'package:mi_proyecto/components/side_menu.dart';

class MiAppScreen extends StatefulWidget {
  const MiAppScreen({super.key});

  @override
  MiAppScreenState createState() => MiAppScreenState();
}

class MiAppScreenState extends State<MiAppScreen> {
  Color _colorActual = Colors.blue; // Color inicial del Container
  final List<Color> _colores = [Colors.blue, Colors.red, Colors.green];
  int _indiceColor = 0;
  final int _selectedIndex = 0;

  void _cambiarColor() {
    setState(() {
      _indiceColor = (_indiceColor + 1) % _colores.length; // Cambia al siguiente color
      _colorActual = _colores[_indiceColor];
    });
  }
  
  void _resetColor() {
    setState(() {
      _colorActual = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi App'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      drawer: const SideMenu(),
      body: Center(
        child: Column(          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              color: _colorActual, // Aplica el color actual
              alignment: Alignment.center,
              child: const Text(
                '¡Cambio de color!',
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 300,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacio entre los botones
                children: [
                  ElevatedButton(
                    onPressed: _cambiarColor, // Cambia el color al presionar
                    child: const Text('Cambiar Color'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _resetColor, // Cambia el color al presionar
                    child: const Text('Resetea Color'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
       bottomNavigationBar:  CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }
}