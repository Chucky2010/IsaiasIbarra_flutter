import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/comentario/comentario_event.dart';
import 'package:mi_proyecto/bloc/comentario/comentario_state.dart';
import 'package:mi_proyecto/data/comentario_repository.dart';
import 'package:mi_proyecto/data/noticia_repository.dart';
import 'package:mi_proyecto/domain/comentario.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class ComentarioBloc extends Bloc<ComentarioEvent, ComentarioState> {
  final ComentarioRepository _comentarioRepository = di<ComentarioRepository>();
  // Utilizamos la inyección de dependencias para acceder a NoticiaBLoc
  final _noticiaRepository = di<NoticiaRepository>();

  ComentarioBloc() : super(ComentarioInitial()) {
    on<LoadComentarios>(_onLoadComentarios);
    on<AddComentario>(_onAddComentario);
    on<BuscarComentarios>(_onBuscarComentarios);
    on<OrdenarComentarios>(_onOrdenarComentarios);
    on<AddReaccion>(_onAddReaccion);
    on<AddSubcomentario>(_onAddSubcomentario);
    on<ActualizarContadorComentarios>(_onActualizarContadorComentarios);
  }

  Future<void> _onLoadComentarios(
    LoadComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    emit(ComentarioLoading());

    try {
      final comentarios = await _comentarioRepository
          .obtenerComentariosPorNoticia(event.noticiaId);
      emit(
        ComentarioLoaded(comentarios: comentarios, noticiaId: event.noticiaId),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(ComentarioError(e));
      }
    }
  }

  Future<void> _onAddComentario(
    AddComentario event,
    Emitter<ComentarioState> emit,
  ) async {
    List<Comentario> comentariosActuales = [];
    if (state is ComentarioLoaded) {
      comentariosActuales = [...(state as ComentarioLoaded).comentarios];
    }
    emit(ComentarioLoading());

    try {
      final comentario = await _comentarioRepository.agregarComentario(
        event.comentario,
      );
      // Agregar el nuevo comentario a la lista actual
      final comentariosActualizadas = [...comentariosActuales, comentario];
      emit(
        ComentarioLoaded(
          comentarios: comentariosActualizadas,
          noticiaId: event.noticiaId,
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(ComentarioError(e));
      }
    }
  }

  Future<void> _onBuscarComentarios(
    BuscarComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    List<Comentario> comentariosActuales = [];
    if (state is ComentarioLoaded) {
      comentariosActuales = [...(state as ComentarioLoaded).comentarios];
    }
    emit(ComentarioLoading());

    final comentariosFiltrados =
        comentariosActuales.where((comentario) {
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
        comentarios: comentariosFiltrados,
        noticiaId: event.noticiaId,
        terminoBusqueda: event.terminoBusqueda,
      ),
    );
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
          comentarios: comentarios,
          noticiaId: currentState.noticiaId,
          criterioOrden: event.ascendente ? 'fecha:asc' : 'fecha:desc',
        ),
      );
    } else {
      // Si no tenemos estado cargado, no podemos ordenar nada
      emit(
        ComentarioError(
          ApiException(
            'No hay comentarios cargados para ordenar',
            statusCode: 404,
          ),
        ),
      );
    }
  }

  Future<void> _onAddReaccion(
    AddReaccion event,
    Emitter<ComentarioState> emit,
  ) async {
    final currentState = state;
    try {
      emit(ReaccionLoading());
      // Llamamos al repositorio para persistir el cambio
      final comentarioResponse = await _comentarioRepository
          .reaccionarComentario(event.comentarioId, event.tipoReaccion);

      if (currentState is ComentarioLoaded) {
        final comentarios = List<Comentario>.from(currentState.comentarios);
        final comentarioIndex = comentarios.indexWhere(
          (c) => c.id == event.comentarioId,
        );

        if (comentarioIndex != -1) {
          comentarios[comentarioIndex] = comentarioResponse;
          emit(
            ComentarioLoaded(
              comentarios: comentarios,
              noticiaId: currentState.noticiaId,
            ),
          );
        } else {
          final comentariosActualizados =
              comentarios.map((comentario) {
                final subcomentarios = comentario.subcomentarios ?? [];
                final subIndex = subcomentarios.indexWhere(
                  (sc) => sc.id == event.comentarioId,
                );
                if (subIndex != -1) {
                  subcomentarios[subIndex] = comentarioResponse;
                  return subcomentarios[subIndex];
                }
                return comentario;
              }).toList();
          emit(
            ComentarioLoaded(
              comentarios: comentariosActualizados,
              noticiaId: currentState.noticiaId,
            ),
          );
        }
      }
    } catch (e) {
      emit(ComentarioError(e is ApiException ? e : ApiException(e.toString())));
    }
  }

  Future<void> _onAddSubcomentario(
    AddSubcomentario event,
    Emitter<ComentarioState> emit,
  ) async {
    List<Comentario> comentariosActuales = [];
    if (state is ComentarioLoaded) {
      comentariosActuales = [...(state as ComentarioLoaded).comentarios];
    }
    emit(ComentarioLoading());

    try {
      final comentarioPrincipalConSub = await _comentarioRepository.agregarSubcomentario(
        event.subcomentario,
      );

      // Agregar el nuevo subcomentario al comentario padre
      final comentarioPadreIndex = comentariosActuales.indexWhere(
        (c) => c.id == event.subcomentario.idSubComentario,
      );

      comentariosActuales[comentarioPadreIndex] =
          comentariosActuales[comentarioPadreIndex].copyWith(
            subcomentarios: comentarioPrincipalConSub.subcomentarios,
          );

      emit(
        ComentarioLoaded(
          comentarios: comentariosActuales,
          noticiaId: event.subcomentario.noticiaId,
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(ComentarioError(e));
      }
    }
  }

  Future<void> _onActualizarContadorComentarios(
    ActualizarContadorComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    emit(ComentarioLoading());

    try {
      await _noticiaRepository.incrementarContadorComentarios(
        event.noticiaId,
        event.cantidad,
      );

      // Emitimos un estado para indicar que el contador fue actualizado
      emit(
        ContadorComentariosActualizado(
          noticiaId: event.noticiaId,
          contadorComentarios: event.cantidad,
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(ComentarioError(e));
      }
    }
  }
}
