import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/categoria/categoria_bloc.dart';
import 'package:mi_proyecto/bloc/categoria/categoria_event.dart';
import 'package:mi_proyecto/bloc/categoria/categoria_state.dart';
import 'package:mi_proyecto/components/floating_add_button.dart';
import 'package:mi_proyecto/components/last_updated_header.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/components/categoria_card.dart';
import 'package:mi_proyecto/components/side_menu.dart';
import 'package:mi_proyecto/components/custom_bottom_navigation_bar.dart';
import 'package:mi_proyecto/components/formulario_categoria.dart';
import 'package:mi_proyecto/domain/categoria.dart';
import 'package:mi_proyecto/helpers/dialog_helper.dart';
import 'package:mi_proyecto/helpers/modal_helper.dart';
import 'package:mi_proyecto/helpers/snackbar_helper.dart';
import 'package:mi_proyecto/helpers/snackbar_manager.dart';

class CategoriaScreen extends StatelessWidget {
  const CategoriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Limpiar cualquier SnackBar existente al entrar a esta pantalla
    // pero solo si no está mostrándose el SnackBar de conectividad
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!SnackBarManager().isConnectivitySnackBarShowing) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });
    return MultiBlocProvider(
      providers: [        BlocProvider<CategoriaBloc>(
          create: (context) => CategoriaBloc()..add(CategoriaInitEvent(forzarRecarga: false)),
        ),
      ],
      child: _CategoriaScreenContent(),
    );
  }
}

class _CategoriaScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriaBloc, CategoriaState>(
      // Optimización 1: Solo notificar cuando hay cambios significativos de estado
      listenWhen: (previous, current) {
        // Solo queremos notificar en los siguientes casos específicos:
        return current is CategoriaError || // Cuando hay errores
               current is CategoriaCreated || // Cuando se crea una categoría
               current is CategoriaUpdated || // Cuando se actualiza una categoría
               current is CategoriaDeleted || // Cuando se elimina una categoría
               current is CategoriaReloaded || // Cuando se recarga la caché forzadamente
               (current is CategoriaLoaded && current.categorias.isEmpty); // Cuando la lista está vacía
      },
      listener: (context, state) {
        // Optimización 2: Manejo de estados más simple y directo
        if (state is CategoriaError) {
          SnackBarHelper.manejarError(context, state.error);
        } else if (state is CategoriaCreated) {
          // Mensaje específico para creación
          SnackBarHelper.mostrarExito(
            context,
            mensaje: CategoriaConstantes.successCreated,
          );
        } else if (state is CategoriaUpdated) {
          // Mensaje específico para actualización
          SnackBarHelper.mostrarExito(
            context,
            mensaje: CategoriaConstantes.successUpdated,
          );
        } else if (state is CategoriaDeleted) {
          SnackBarHelper.mostrarExito(
            context,
            mensaje: CategoriaConstantes.successDeleted,
          );
        } else if (state is CategoriaReloaded) {
          // Mensaje específico para cuando se recarga la caché forzadamente
          SnackBarHelper.mostrarExito(
            context,
            mensaje: 'Categorías recargadas correctamente',
          );
        } else if (state is CategoriaLoaded && state.categorias.isEmpty) {
          // Mensaje para lista vacía
          SnackBarHelper.mostrarInfo(
            context,
            mensaje: CategoriaConstantes.listaVacia,
          );
        }
      },
      builder: (context, state) {
        DateTime? lastUpdated;
        if (state is CategoriaLoaded) {
          lastUpdated = state.lastUpdated;
        }
        return Scaffold(          appBar: AppBar(
            title: const Text('Categorías de Noticias'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () =>
                    // Forzar la recarga de la caché desde el servidor cuando se presiona el icono de refresh
                    context.read<CategoriaBloc>().add(CategoriaInitEvent(forzarRecarga: true)),
              ),
            ],
          ),
          drawer: const SideMenu(),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              LastUpdatedHeader(lastUpdated: lastUpdated),
              Expanded(child: _construirCuerpoCategorias(context, state)),
            ],
          ),
          floatingActionButton: FloatingAddButton(
            onPressed: () async {
              final categoria = await ModalHelper.mostrarDialogo<Categoria>(
                context: context,
                title: 'Agregar Categoría',
                child: const FormularioCategoria(),
              );

              // Si se obtuvo una categoría del formulario y el contexto sigue montado
              if (categoria != null && context.mounted) {
                // Usar el BLoC para crear la categoría
                context.read<CategoriaBloc>().add(
                  CategoriaCreateEvent(categoria),
                );
              }
            },
            tooltip: 'Agregar Categoría',
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: const CustomBottomNavigationBar(
            selectedIndex: 0,
          ),
        );
      },
    );
  }
  Widget _construirCuerpoCategorias(
    BuildContext context,
    CategoriaState state,
  ) {    // Función reutilizable para la acción de refresh
    Future<void> onRefresh() async {
      await Future.delayed(const Duration(milliseconds: 800));
      if (context.mounted) {
        context.read<CategoriaBloc>().add(CategoriaInitEvent(forzarRecarga: false));
      }
    }
    
    // Widget reutilizable para RefreshIndicator
    Widget buildRefreshableList({required Widget child}) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(), // Necesario para pull-to-refresh
          children: [child],
        ),
      );
    }

    if (state is CategoriaLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is CategoriaError) {
      return buildRefreshableList(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.error.message,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),                ElevatedButton(
                  onPressed: () => context.read<CategoriaBloc>().add(CategoriaInitEvent(forzarRecarga: true)),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (state is CategoriaLoaded) {
      if (state.categorias.isNotEmpty) {
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: state.categorias.length,
            itemBuilder: (context, index) {
              final categoria = state.categorias[index];
              return CategoriaCard(
                categoria: categoria,
                onEdit: () => _editarCategoria(context, categoria),
                onDelete: () => _eliminarCategoria(context, categoria),
              );
            },
          ),
        );
      } else {
        return buildRefreshableList(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Center(
              child: Text(CategoriaConstantes.listaVacia),
            ),
          ),
        );
      }
    } else {
      return Container();
    }
  }
  
  // Extraer la lógica de edición a un método separado para mejorar la legibilidad
  Future<void> _editarCategoria(BuildContext context, Categoria categoria) async {
    final categoriaEditada = await ModalHelper.mostrarDialogo<Categoria>(
      context: context,
      title: 'Editar Categoría',
      child: FormularioCategoria(categoria: categoria),
    );
    
    if (categoriaEditada != null && context.mounted) {
      // Usar copyWith para mantener el ID original y actualizar el resto de datos
      final categoriaActualizada = categoriaEditada.copyWith(id: categoria.id);
      
      // Usar el BLoC para actualizar la categoría
      context.read<CategoriaBloc>().add(CategoriaUpdateEvent(categoriaActualizada));
    }
  }
  
  // Extraer la lógica de eliminación a un método separado para mejorar la legibilidad
  Future<void> _eliminarCategoria(BuildContext context, Categoria categoria) async {
    // Mostrar diálogo de confirmación
    final confirmar = await DialogHelper.mostrarConfirmacion(
      context: context,
      titulo: 'Confirmar eliminación',
      mensaje: '¿Estás seguro de eliminar la categoría "${categoria.nombre}"?',
      textoCancelar: 'Cancelar',
      textoConfirmar: 'Eliminar',
    );
    
    if (confirmar == true && context.mounted) {
      context.read<CategoriaBloc>().add(CategoriaDeleteEvent(categoria.id!));
    }
  }
}
