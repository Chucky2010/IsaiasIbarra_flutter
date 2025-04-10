import 'package:flutter/material.dart';
import 'package:kgaona/components/custom_bottom_navigation_bar.dart';
import 'package:kgaona/components/side_menu.dart';

class ContadorScreen extends StatefulWidget {
  const ContadorScreen({super.key, required this.title});

  final String title;

  @override
  State<ContadorScreen> createState() => _ContadorScreenState();
}

class _ContadorScreenState extends State<ContadorScreen> {
  int _counter = 0;
  final int _selectedIndex = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    String message;
    Color messageColor;

    if (_counter > 0) {
      message = 'Contador en positivo';
      messageColor = Colors.green;
    } else if (_counter == 0) {
      message = 'Contador en cero';
      messageColor = Colors.black;
    } else {
      message = 'Contador en negativo';
      messageColor = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: const SideMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(message, style: TextStyle(fontSize: 18, color: messageColor)),
            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: 'decrement',
              onPressed: _decrementCounter,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: 'increment',
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: 'reset',
              onPressed: () {
                setState(() {
                  _counter = 0;
                });
              },
              tooltip: 'Reset',
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),          
      bottomNavigationBar:  CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }
}