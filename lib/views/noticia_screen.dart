import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/categoria/categoria_bloc.dart';
import 'package:mi_proyecto/bloc/categoria/categoria_event.dart';
import 'package:mi_proyecto/bloc/categoria/categoria_state.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_bloc.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_event.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_state.dart';
import 'package:mi_proyecto/components/floating_add_button.dart';
import 'package:mi_proyecto/components/formulario_noticia.dart';
import 'package:mi_proyecto/components/last_updated_header.dart';
import 'package:mi_proyecto/components/noticia_card.dart';
import 'package:mi_proyecto/components/reporte_dialog.dart';
import 'package:mi_proyecto/components/side_menu.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:mi_proyecto/domain/categoria.dart';
import 'package:mi_proyecto/domain/noticia.dart';
import 'package:mi_proyecto/helpers/categoria_helper.dart';
import 'package:mi_proyecto/helpers/dialog_helper.dart';
import 'package:mi_proyecto/helpers/modal_helper.dart';
import 'package:mi_proyecto/helpers/snackbar_helper.dart';
import 'package:mi_proyecto/helpers/snackbar_manager.dart';
import 'package:mi_proyecto/views/categoria_screen.dart';
import 'package:mi_proyecto/views/preferencia_screen.dart';

class NoticiaScreen extends StatelessWidget {
  const NoticiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Limpiar cualquier SnackBar existente al entrar a esta pantalla
    // pero solo si no está mostrándose el SnackBar de conectividad
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!SnackBarManager().isConnectivitySnackBarShowing) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });    // Usamos el NoticiaBloc global que viene del MultiBlocProvider en main.dart
    return BlocProvider<CategoriaBloc>(
      create: (context) => CategoriaBloc()..add(CategoriaInitEvent()),
      child: _NoticiaScreenContent(),
    );
  }
}

class _NoticiaScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoticiaBloc, NoticiaState>(
      listener: (context, state) {
        if (state is NoticiaError) {
          SnackBarHelper.manejarError(
            context,
            state.error,
          );
        }else if (state is NoticiaCreated) {
          SnackBarHelper.mostrarExito(
            context,
            mensaje: NoticiasConstantes.successCreated,
          );
        }else if (state is NoticiaUpdated) {
          SnackBarHelper.mostrarExito(
            context,
            mensaje: NoticiasConstantes.successUpdated,
          );
        }else if (state is NoticiaDeleted) {
          SnackBarHelper.mostrarExito(
            context,
            mensaje: NoticiasConstantes.successDeleted,
          );
        }else if (state is NoticiaFiltered) {
          SnackBarHelper.mostrarExito(
            context,
            mensaje: "Noticias filtradas correctamente",
          );
        }else if (state is NoticiaLoaded) { 
          if (state.noticias.isEmpty) {
            SnackBarHelper.mostrarInfo(
              context,
              mensaje: NoticiasConstantes.listaVacia,
            );
          }else{
            SnackBarHelper.mostrarExito(
              context,
              mensaje: 'Noticias cargadas correctamente',
            );
          }
        }
      },
      builder: (context, state) {
        DateTime? lastUpdated;
        if (state is NoticiaLoaded) {
          lastUpdated = state.lastUpdated;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text(NoticiasConstantes.tituloApp),
            centerTitle: true,
            actions: [              
              IconButton(
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filtrar por categorías',
                onPressed: () async {
                  // Obtener el NoticiaBloc antes de navegar
                  final noticiaBloc = context.read<NoticiaBloc>();
                  // Navegar a la pantalla de preferencias proporcionando el NoticiaBloc actual
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: noticiaBloc,
                        child: const PreferenciaScreen(),
                      ),
                    ),
                  );
                  // No necesitamos hacer nada más aquí porque la pantalla de preferencias
                  // ya se encarga de emitir el evento de filtrado al NoticiaBloc
                },
              ),
              IconButton(
                icon: const Icon(Icons.category),
                tooltip: 'Categorías',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoriaScreen(),
                    ),
                  );
                },
              ),
            ],
          ),          drawer: const SideMenu(),
          body: Column(
            children: [
              LastUpdatedHeader(lastUpdated: lastUpdated),
              Expanded(child: _construirCuerpoNoticias(context, state)),
            ],
          ),
          floatingActionButton: BlocBuilder<CategoriaBloc, CategoriaState>(
            builder: (context, categoriaState) {
              return FloatingAddButton(
                onPressed: () async {

                  // Si las categorías aún se están cargando, inicia la carga
                  if (categoriaState is! CategoriaLoaded) {
                    context.read<CategoriaBloc>().add(CategoriaInitEvent());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cargando categorías...')),
                    );
                    return;
                  }

                  final List<Categoria> categorias = categoriaState.categorias;

                  final noticia = await ModalHelper.mostrarDialogo<Noticia>(
                    context: context,
                    title: 'Agregar Noticia',
                    child: FormularioNoticia(categorias: categorias),
                  );

                  // Si se obtuvo una categoría del formulario y el contexto sigue montado
                  if (noticia != null && context.mounted) {
                    // Usar el BLoC para crear la categoría
                    context.read<NoticiaBloc>().add(
                      AddNoticiaEvent(noticia),
                    );
                  }
                },
                tooltip: 'Agregar Noticia',
              );              
            },            
          ),
        );        
      }
    );
  }

  Widget _construirCuerpoNoticias(
    BuildContext context,
    NoticiaState state,
  ) {
    if (state is NoticiaLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NoticiaError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.error.message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<NoticiaBloc>().add(FetchNoticiasEvent()),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    } else if (state is NoticiaLoaded) {
      // Obtener las categorías del BlocProvider
      final categoriaState = context.watch<CategoriaBloc>().state;
      List<Categoria> categorias = [];
      
      if (categoriaState is CategoriaLoaded) {
        categorias = categoriaState.categorias;
      }
      if (state.noticias.isNotEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 1200));
            if (context.mounted) {
              context.read<NoticiaBloc>().add(FetchNoticiasEvent());
            }
          },
          child: ListView.builder(
            physics:
                const AlwaysScrollableScrollPhysics(), // Necesario para pull-to-refresh
            itemCount: state.noticias.length,
            itemBuilder: (context, index) {
              final noticia= state.noticias[index];
              return Dismissible(
                key: Key(noticia.id ?? UniqueKey().toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.startToEnd,
                confirmDismiss: (direction) async {
                  return await DialogHelper.mostrarConfirmacion(
                    context: context,
                    titulo: 'Confirmar eliminación',
                    mensaje: '¿Estás seguro de que deseas eliminar esta noticia?',
                    textoCancelar: 'Cancelar',
                    textoConfirmar: 'Eliminar',
                  );
                },
                onDismissed: (direction) {
                  context.read<NoticiaBloc>().add(DeleteNoticiaEvent(noticia.id!));
                },
                child: NoticiaCard(
                  noticia: noticia,
                  onReport: () {                    // Mostrar el diálogo de reportes
                    ReporteDialog.mostrarDialogoReporte(
                      context: context, 
                      noticia: noticia,
                    );
                  },
                  onEdit: () async {
                  // Solo muestra el formulario si las categorías están cargadas
                  if (categorias.isEmpty) {
                    SnackBarHelper.mostrarInfo(
                      context, 
                      mensaje: 'Cargando categorías...'
                    );
                    context.read<CategoriaBloc>().add(CategoriaInitEvent());
                    return;
                  }
                  
                  final noticiaEditada = await ModalHelper.mostrarDialogo<Noticia>(
                    context: context,
                    title: 'Editar Noticia',
                    child: FormularioNoticia(
                      noticia: noticia,
                      categorias: categorias,
                    ),
                  );
                  
                  if (noticiaEditada != null && context.mounted) {
                    // Usar copyWith para mantener el ID original y actualizar el resto de datos
                    final noticiaActualizada = noticiaEditada.copyWith(id: noticia.id);
                    context.read<NoticiaBloc>().add(
                      UpdateNoticiaEvent(noticiaActualizada),
                    );
                  }
                },
                  categoriaNombre: CategoriaHelper.obtenerNombreCategoria(
                    noticia.categoriaId?? '',
                    categorias,
                  ),
                ),
              );   
            } 
          ),       
        );
      } else {
          // Añadir esta parte para manejar el caso de lista vacía
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 1200));
              if (context.mounted) {
                context.read<NoticiaBloc>().add(FetchNoticiasEvent());
              }            
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: const Center(child: Text(NoticiasConstantes.listaVacia)),
                ),
              ],
            ),
          );
        }
    } else {
      return Container();
    }
  }
}

