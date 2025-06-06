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
  Widget build(BuildContext context) {    return Scaffold(      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        elevation: 4.0, // Añade elevación para mejor contraste visual
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      drawer: const SideMenu(),      body: BlocBuilder<ContadorBloc, ContadorState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Presiona los botones para modificar el contador',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${state.valor}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),               
                 Text(
                  state.mensaje,
                  style: TextStyle(
                    fontSize: 18, 
                    color: state.colorMensaje,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),              
                if (state.status == ContadorStatus.loading)
                  CircularProgressIndicator(
                    color: colorScheme.primary,
                    strokeWidth: 3.0,
                  ),
                if (state.status == ContadorStatus.error)
                  Card(
                    color: colorScheme.errorContainer,
                    margin: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        state.errorMessage ?? 'Ha ocurrido un error',
                        style: TextStyle(
                          color: colorScheme.onErrorContainer,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Builder(
        builder: (context) {
          final colorScheme = Theme.of(context).colorScheme;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'decrement',
                  onPressed: () => context.read<ContadorBloc>().add(ContadorDecrementEvent()),
                  tooltip: 'Decrement',
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'increment',
                  onPressed: () => context.read<ContadorBloc>().add(ContadorIncrementEvent()),
                  tooltip: 'Increment',
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'reset',
                  onPressed: () => context.read<ContadorBloc>().add(ContadorResetEvent()),
                  tooltip: 'Reset',
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  elevation: 4.0,
                  child: const Icon(Icons.refresh),
                ),              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }
}