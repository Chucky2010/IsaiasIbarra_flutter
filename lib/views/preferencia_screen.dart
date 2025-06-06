import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/categoria/categoria_bloc.dart';
import 'package:mi_proyecto/bloc/categoria/categoria_event.dart';
import 'package:mi_proyecto/bloc/categoria/categoria_state.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_bloc.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_event.dart';
import 'package:mi_proyecto/bloc/preferencia/preferencia_bloc.dart';
import 'package:mi_proyecto/bloc/preferencia/preferencia_event.dart';
import 'package:mi_proyecto/bloc/preferencia/preferencia_state.dart';
import 'package:mi_proyecto/domain/categoria.dart';
import 'package:mi_proyecto/helpers/snackbar_helper.dart';
import 'package:mi_proyecto/helpers/snackbar_manager.dart';

class PreferenciaScreen extends StatelessWidget {
  const PreferenciaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Limpiar cualquier SnackBar existente al entrar a esta pantalla
    // pero solo si no está mostrándose el SnackBar de conectividad
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!SnackBarManager().isConnectivitySnackBarShowing) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });

    // Obtener referencia al NoticiaBloc existente para filtrar después
    final noticiaBloc = BlocProvider.of<NoticiaBloc>(context, listen: false);

    return MultiBlocProvider(
      providers: [
        BlocProvider<PreferenciaBloc>(
          create: (context) => PreferenciaBloc()..add(LoadPreferences()),
        ),
        BlocProvider<CategoriaBloc>(
          create: (context) => CategoriaBloc()..add(CategoriaInitEvent()),
        ),
      ],
      child: BlocConsumer<PreferenciaBloc, PreferenciaState>(
        listener: (context, state) {
          if (state is PreferenciaError) {
            SnackBarHelper.manejarError(context, state.error);
          } else if (state is PreferenciasSaved) {
            // Emitimos evento para filtrar noticias inmediatamente
            noticiaBloc.add(
              FilterNoticiasByPreferenciasEvent(state.categoriasSeleccionadas),
            );

            // Mostramos mensaje de éxito
            SnackBarHelper.mostrarExito(
              context,
              mensaje: 'Preferencias guardadas correctamente',
            );

            // Cerramos pantalla después de un breve delay
            Future.delayed(const Duration(milliseconds: 800), () {
              if (context.mounted) {
                Navigator.pop(context, state.categoriasSeleccionadas);
              }
            });
          }
        },
        builder: (context, prefState) {          // Obtener el tema actual para adaptar colores y estilos
          final theme = Theme.of(context);
          
          return Scaffold(
            appBar: AppBar(
              title: const Text('Preferencias'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Restablecer filtros',
                  onPressed:
                      () => context.read<PreferenciaBloc>().add(ResetFilters()),
                ),
              ],
            ),
            // Usar el color de fondo del tema en lugar de blanco fijo
            backgroundColor: theme.scaffoldBackgroundColor,
            body: _construirCuerpoPreferencias(context, prefState),
            bottomNavigationBar: _construirBarraInferior(context, prefState),
          );
        },
      ),
    );
  }
  Widget _construirCuerpoPreferencias(
    BuildContext context,
    PreferenciaState prefState,
  ) {
    // Obtener el tema actual
    final theme = Theme.of(context);
    
    return BlocBuilder<CategoriaBloc, CategoriaState>(
      builder: (context, catState) {
        if (catState is CategoriaLoading ||
            prefState is PreferenciaLoading ||
            prefState is PreferenciasSaved) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              backgroundColor: theme.colorScheme.surface,
            ),
          );
        } else if (catState is CategoriaError) {
          return _construirWidgetError(
            context,
            'Error al cargar categorías: ${catState.error.message}',
            () => context.read<CategoriaBloc>().add(CategoriaInitEvent()),
          );
        } else if (prefState is PreferenciaError) {
          return _construirWidgetError(
            context,
            'Error de preferencias: ${prefState.error.message}',
            () => context.read<PreferenciaBloc>().add(LoadPreferences()),
          );
        } else if (catState is CategoriaLoaded) {
          final categorias = catState.categorias;
          return _construirListaCategorias(context, prefState, categorias);
        }
        return Center(
          child: Text(
            'Estado desconocido',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        );
      },
    );
  }
  Widget _construirListaCategorias(
    BuildContext context,
    PreferenciaState state,
    List<Categoria> categorias,
  ) {
    // Obtener el tema actual
    final theme = Theme.of(context);
    
    if (categorias.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 48,
              color: theme.colorScheme.secondary.withValues(alpha:0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay categorías disponibles',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: categorias.length,
      // Usar el color del divisor del tema
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: theme.dividerColor,
      ),
      itemBuilder: (context, index) {
        final categoria = categorias[index];
        // Verificar que el ID no sea nulo
        if (categoria.id == null || categoria.id!.isEmpty) {
          return ListTile(
            title: Text(
              'Categoría sin identificador válido',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            leading: Icon(Icons.error_outline, color: theme.colorScheme.error),
          );
        }

        // Usar BlocBuilder aislado para este ítem específico
        return BlocBuilder<PreferenciaBloc, PreferenciaState>(
          // Usar el buildWhen para reducir reconstrucciones innecesarias
          buildWhen: (previous, current) {
            // Solo reconstruir si cambia la selección de esta categoría específica
            if (previous is PreferenciasLoaded &&
                current is PreferenciasLoaded) {
              final prevSelected = previous.categoriasSeleccionadas.contains(
                categoria.id,
              );
              final currSelected = current.categoriasSeleccionadas.contains(
                categoria.id,
              );
              return prevSelected != currSelected;
            }
            return true;
          },
          builder: (context, state) {
            final isSelected =
                state is PreferenciasLoaded &&
                state.categoriasSeleccionadas.contains(categoria.id);            final theme = Theme.of(context);
            final isDark = theme.brightness == Brightness.dark;
            
            return Card(
              // Usar un color más suave para las tarjetas según el modo
              color: isSelected 
                ? (isDark 
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.2)
                  : theme.colorScheme.primaryContainer.withValues(alpha: 0.1))
                : theme.cardColor,
              elevation: isSelected ? 1.0 : 0.5,
              margin: const EdgeInsets.symmetric(vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: isSelected ? BorderSide(
                  color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  width: 1.5,
                ) : BorderSide.none,
              ),
              child: CheckboxListTile(
                title: Text(
                  categoria.nombre,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  categoria.descripcion,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha:0.7),
                  ),
                ),
                value: isSelected,
                onChanged:
                    (_) => _toggleCategoria(context, categoria.id!, isSelected),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: theme.colorScheme.primary,
                checkColor: theme.colorScheme.onPrimary,
                secondary: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.secondary,
                      )
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        );
      },
    );
  }
  Widget _construirBarraInferior(BuildContext context, PreferenciaState state) {
    // Obtener el tema actual para usar sus colores y estilos
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Determinar si el botón debe estar habilitado
    final bool isEnabled =
        state is! PreferenciaError && state is! PreferenciaLoading;

    // Obtener el número de categorías seleccionadas de manera segura
    final int numCategorias =
        state is PreferenciasLoaded ? state.categoriasSeleccionadas.length : 0;

    return SafeArea(
      child: BottomAppBar(
        // Usar colores del tema para la barra inferior
        color: isDark 
            ? theme.bottomAppBarTheme.color ?? theme.colorScheme.surface
            : theme.colorScheme.surface,
        elevation: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: state is PreferenciaError 
                        ? theme.colorScheme.error 
                        : theme.colorScheme.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state is PreferenciaError
                        ? 'Error al cargar preferencias'
                        : 'Seleccionadas: $numCategorias',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: state is PreferenciaError 
                          ? theme.colorScheme.error 
                          : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed:
                    isEnabled ? () => _aplicarFiltros(context, state) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  // Añadir forma redondeada
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const 
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.check, size: 18),
                    SizedBox(width: 4),
                    Text(
                      'Aplicar filtros',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _construirWidgetError(
    BuildContext context,
    String message,
    VoidCallback onRetry,
  ) {
    // Obtener el tema actual para usar sus colores y estilos
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline, 
            size: 48, 
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.refresh),
            label: const Text(
              'Reintentar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleCategoria(
    BuildContext context,
    String categoriaId,
    bool isSelected,
  ) {
    // Implementar actualización local para feedback inmediato
    final currentState = context.read<PreferenciaBloc>().state;
    if (currentState is PreferenciasLoaded) {
      // Luego enviar el evento para persistir el cambio
      context.read<PreferenciaBloc>().add(
        ChangeCategory(categoriaId, !isSelected),
      );
    }
  }
  void _aplicarFiltros(BuildContext context, PreferenciaState state) {
    // Verificar que no sea un estado de error
    if (state is PreferenciaError) {
      SnackBarHelper.mostrarAdvertencia(
        context,
        mensaje: 'No se pueden aplicar los filtros debido a un error',
      );
      return;
    }

    // Verificar que sea un estado que tenga categorías seleccionadas
    if (state is PreferenciasLoaded) {
      // Guardar preferencias - esto ya disparará el filtrado desde el listener
      context.read<PreferenciaBloc>().add(
        SavePreferences(state.categoriasSeleccionadas),
      );
      // Ya no aplicamos el filtro aquí, solo en el listener cuando se guarda
    } else {
      // Manejar caso donde el estado no tiene categorías seleccionadas
      SnackBarHelper.mostrarAdvertencia(
        context,
        mensaje: 'Estado de preferencias inválido',
      );
    }
  }
}
