import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/contador/contador_bloc.dart';
import 'package:mi_proyecto/bloc/contador/contador_event.dart';
import 'package:mi_proyecto/bloc/contador/contador_state.dart';
import 'package:mi_proyecto/components/custom_bottom_navigation_bar.dart';
import 'package:mi_proyecto/components/side_menu.dart';

class ContadorScreen extends StatelessWidget {
  const ContadorScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContadorBloc(),
      child: _ContadorView(title: title),
    );
  }
}

class _ContadorView extends StatelessWidget {
  const _ContadorView({required this.title});

  final String title;
  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      drawer: const SideMenu(),
      body: BlocBuilder<ContadorBloc, ContadorState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('You have pushed the button this many times:'),
                Text(
                  '${state.valor}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  state.mensaje,
                  style: TextStyle(fontSize: 18, color: state.colorMensaje),
                ),
                const SizedBox(height: 16),
                if (state.status == ContadorStatus.loading)
                  const CircularProgressIndicator(),
                if (state.status == ContadorStatus.error)
                  Text(
                    state.errorMessage ?? 'Ha ocurrido un error',
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: 'decrement',
              onPressed: () => context.read<ContadorBloc>().add(ContadorDecrementEvent()),
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: 'increment',
              onPressed: () => context.read<ContadorBloc>().add(ContadorIncrementEvent()),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: 'reset',
              onPressed: () => context.read<ContadorBloc>().add(ContadorResetEvent()),
              tooltip: 'Reset',
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }
}