import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/comentario/comentario_event.dart';
import 'package:kgaona/bloc/comentario/comentario_state.dart';
import 'package:kgaona/data/comentario_repository.dart';
import 'package:kgaona/domain/comentario.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class ComentarioBloc extends Bloc<ComentarioEvent, ComentarioState> {
  final ComentarioRepository _comentarioRepository = di<ComentarioRepository>();

  ComentarioBloc() : super(ComentarioInitial()) {
    on<LoadComentarios>(_onLoadComentarios);
    on<AddComentario>(_onAddComentario);
    on<GetNumeroComentarios>(_onGetNumeroComentarios);
    on<BuscarComentarios>(_onBuscarComentarios);
    on<OrdenarComentarios>(_onOrdenarComentarios);
    on<AddReaccion>(_onAddReaccion);
    on<AddSubcomentario>(_onAddSubcomentario);
  }

  Future<void> _onLoadComentarios(
    LoadComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    emit(ComentarioLoading());

    try {
      final comentarios = await _comentarioRepository
          .obtenerComentariosPorNoticia(event.noticiaId);
      emit(ComentarioLoaded(comentarios, event.noticiaId));
    } catch (e) {
      if (e is ApiException) {
        emit(
          ComentarioError(
            'Error al cargar comentarios',
            e,
            TipoOperacionComentario.cargar,
          ),
        );
      }
    }
  }

  Future<void> _onAddComentario(
    AddComentario event,
    Emitter<ComentarioState> emit,
  ) async {
    emit(ComentarioLoading());

    try {
      await _comentarioRepository.agregarComentario(event.comentario);

      // Recargar los comentarios para mostrar la lista actualizada
      final comentarios = await _comentarioRepository
          .obtenerComentariosPorNoticia(event.noticiaId);

      emit(ComentarioLoaded(comentarios, event.noticiaId));
    } catch (e) {
      if (e is ApiException) {
        emit(
          ComentarioError(
            'Error al agregar comentario',
            e,
            TipoOperacionComentario.agregar,
          ),
        );
      }
    }
  }

  Future<void> _onGetNumeroComentarios(
    GetNumeroComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    emit(ComentarioLoading());

    try {
      final numeroComentarios = await _comentarioRepository
          .obtenerNumeroComentarios(event.noticiaId);
      emit(NumeroComentariosLoaded(numeroComentarios, event.noticiaId));
    } catch (e) {
      if (e is ApiException) {
        emit(
          ComentarioError(
            'Error al obtener número de comentarios',
            e,
            TipoOperacionComentario.obtenerNumero,
          ),
        );
      }
    }
  }

  Future<void> _onBuscarComentarios(
    BuscarComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    emit(ComentarioLoading());

    try {
      final todosComentarios = await _comentarioRepository
          .obtenerComentariosPorNoticia(event.noticiaId);

      final comentariosFiltrados =
          todosComentarios.where((comentario) {
            // Busca en el texto, autor o fecha del comentario
            return comentario.texto.toLowerCase().contains(
                  event.terminoBusqueda.toLowerCase(),
                ) ||
                comentario.autor.toLowerCase().contains(
                  event.terminoBusqueda.toLowerCase(),
                ) ||
                comentario.fecha.toLowerCase().contains(
                  event.terminoBusqueda.toLowerCase(),
                );
          }).toList();

      emit(
        ComentariosFiltrados(
          comentariosFiltrados,
          event.noticiaId,
          event.terminoBusqueda,
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(
          ComentarioError(
            'Error al buscar comentarios',
            e,
            TipoOperacionComentario.buscar,
          ),
        );
      }
    }
  }

  Future<void> _onOrdenarComentarios(
    OrdenarComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    // Si ya tenemos los comentarios cargados en el estado actual, los usamos
    if (state is ComentarioLoaded) {
      final currentState = state as ComentarioLoaded;
      final List<Comentario> comentarios = List<Comentario>.from(
        currentState.comentarios,
      );

      // Ordenamos por fecha
      comentarios.sort((a, b) {
        return event.ascendente
            ? a.fecha.compareTo(b.fecha) // Orden ascendente
            : b.fecha.compareTo(a.fecha); // Orden descendente
      });

      // Emitimos un nuevo estado con los comentarios ordenados
      emit(
        ComentariosOrdenados(
          comentarios,
          currentState.noticiaId,
          event.ascendente ? 'fecha:asc' : 'fecha:desc',
        ),
      );
    } else {
      // Si no tenemos estado cargado, no podemos ordenar nada
      emit(
        ComentarioError(
          'No hay comentarios para ordenar',
          ApiException('No hay comentarios cargados para ordenar'),
          TipoOperacionComentario.ordenar,
        ),
      );
    }
  }  Future<void> _onAddReaccion(
    AddReaccion event,
    Emitter<ComentarioState> emit,
  ) async {
    // Guardar el estado actual para no perderlo
    ComentarioState? estadoActual = state;

    // Si estamos en un estado de comentarios cargados, podemos proceder
    if (estadoActual is ComentarioLoaded) {
      // Sólo verificamos que estemos en un estado válido
    } else {
      // Si no tenemos un estado cargado, no podemos actualizar
      emit(ComentarioError(
        'No se pueden actualizar las reacciones en este momento',
        ApiException('No hay comentarios cargados para actualizar'),
        TipoOperacionComentario.reaccionar,
      ));
      return;
    }
    
    try {
      // Aplicar la reacción sin emitir un estado de carga para evitar parpadeos en la UI
      await _comentarioRepository.reaccionarComentario(
        event.comentarioId,
        event.tipoReaccion,
        event.incrementar,
        event.comentarioPadreId,
      );
      
      // No emitimos ningún estado nuevo, la recarga se manejará desde los widgets
    } catch (e) {
      emit(ComentarioError(
        'Error al reaccionar al comentario', 
        e is ApiException ? e : ApiException(e.toString()),
        TipoOperacionComentario.reaccionar,
      ));
    }
  }

  Future<void> _onAddSubcomentario(
    AddSubcomentario event,
    Emitter<ComentarioState> emit,
  ) async {
    emit(ComentarioLoading());

    try {
      await _comentarioRepository.agregarSubcomentario(event.subcomentario);

      // Recargar los comentarios para mostrar la lista actualizada
      final comentarios = await _comentarioRepository
          .obtenerComentariosPorNoticia(event.subcomentario.noticiaId);

      emit(ComentarioLoaded(comentarios, event.subcomentario.noticiaId));
    } catch (e) {
      if (e is ApiException) {
        emit(
          ComentarioError(
            'Error al agregar subcomentario',
            e,
            TipoOperacionComentario.agregarSubcomentario,
          ),
        );
      }
    }
  }
}
