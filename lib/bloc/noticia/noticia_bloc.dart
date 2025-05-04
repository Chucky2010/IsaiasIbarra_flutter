import 'package:bloc/bloc.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_event.dart';
import 'package:mi_proyecto/bloc/noticia/noticia_state.dart';
import 'package:mi_proyecto/constants/constants.dart';
import 'package:mi_proyecto/data/noticia_repository.dart';
import 'package:mi_proyecto/domain/noticia.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class NoticiaBloc extends Bloc<NoticiaEvent, NoticiaState> {
  final NoticiaRepository noticiaRepository = di<NoticiaRepository>();
  
  NoticiaBloc() : super(NoticiaInitial()) {
    on<NoticiaInitEvent>(_onInit);
    on<NoticiaRefreshEvent>(_onRefresh);
    on<NoticiaLoadMoreEvent>(_onLoadMore);
    on<NoticiaCreateEvent>(_onCreate);
    on<NoticiaUpdateEvent>(_onUpdate);
    on<NoticiaDeleteEvent>(_onDelete);
  }

  Future<void> _onInit(NoticiaInitEvent event, Emitter<NoticiaState> emit) async {
    emit(NoticiaLoading());
    try {
      final noticias = await noticiaRepository.getPaginatedNoticias(
        pageNumber: 1,
        pageSize: Constants.tamanoPaginaConst,
      );
      emit(NoticiaLoaded(
        noticias: noticias,
        hasMore: noticias.length >= Constants.tamanoPaginaConst,
        currentPage: 1,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError('Error al cargar noticias: ${e.message}', statusCode: e.statusCode));
      } else {
        emit(NoticiaError('Error al cargar noticias: ${e.toString()}'));
      }
    }
  }

  Future<void> _onRefresh(NoticiaRefreshEvent event, Emitter<NoticiaState> emit) async {
    emit(NoticiaLoading());
    try {
      final noticias = await noticiaRepository.getPaginatedNoticias(
        pageNumber: 1,
        pageSize: Constants.tamanoPaginaConst,
      );
      emit(NoticiaLoaded(
        noticias: noticias,
        hasMore: noticias.length >= Constants.tamanoPaginaConst,
        currentPage: 1,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      if (e is ApiException) {
        emit(NoticiaError('Error al refrescar noticias: ${e.message}', statusCode: e.statusCode));
      } else {
        emit(NoticiaError('Error al refrescar noticias: ${e.toString()}'));
      }
    }
  }

  Future<void> _onLoadMore(NoticiaLoadMoreEvent event, Emitter<NoticiaState> emit) async {
    final currentState = state;
    if (currentState is NoticiaLoaded) {
      try {
        final nextPage = currentState.currentPage + 1;
        final nuevasNoticias = await noticiaRepository.getPaginatedNoticias(
          pageNumber: nextPage,
          pageSize: Constants.tamanoPaginaConst,
        );
        
        if (nuevasNoticias.isEmpty) {
          emit(currentState.copyWith(hasMore: false));
        } else {
          // Filtrar duplicados (por si acaso)
          final noticiasActualizadas = List<Noticia>.from(currentState.noticias);
          for (var noticia in nuevasNoticias) {
            if (!noticiasActualizadas.contains(noticia)) {
              noticiasActualizadas.add(noticia);
            }
          }
          
          emit(NoticiaLoaded(
            noticias: noticiasActualizadas,
            hasMore: nuevasNoticias.length >= Constants.tamanoPaginaConst,
            currentPage: nextPage,
            lastUpdated: DateTime.now(),
          ));
        }
      } catch (e) {
        if (e is ApiException) {
          emit(NoticiaError('Error al cargar más noticias: ${e.message}', statusCode: e.statusCode));
          // Restaurar el estado anterior
          emit(currentState);
        } else {
          emit(NoticiaError('Error al cargar más noticias: ${e.toString()}'));
          // Restaurar el estado anterior
          emit(currentState);
        }
      }
    }
  }

  Future<void> _onCreate(NoticiaCreateEvent event, Emitter<NoticiaState> emit) async {
    final currentState = state;
    if (currentState is NoticiaLoaded) {
      try {
        await noticiaRepository.createNoticia(event.noticia);
        
        // Actualizar la lista de noticias
        final noticiasActualizadas = [event.noticia, ...currentState.noticias];
        
        emit(NoticiaLoaded(
          noticias: noticiasActualizadas,
          hasMore: currentState.hasMore,
          currentPage: currentState.currentPage,
          lastUpdated: DateTime.now(),
        ));
      } catch (e) {
        if (e is ApiException) {
          emit(NoticiaError('Error al crear noticia: ${e.message}', statusCode: e.statusCode));
          // Restaurar el estado anterior
          emit(currentState);
        } else {
          emit(NoticiaError('Error al crear noticia: ${e.toString()}'));
          // Restaurar el estado anterior
          emit(currentState);
        }
      }
    }
  }

  Future<void> _onUpdate(NoticiaUpdateEvent event, Emitter<NoticiaState> emit) async {
    final currentState = state;
    if (currentState is NoticiaLoaded) {
      try {
        await noticiaRepository.updateNoticia(event.noticia);
        
        // Actualizar la lista de noticias
        final noticiasActualizadas = currentState.noticias.map((noticia) {
          return noticia.id == event.noticia.id ? event.noticia : noticia;
        }).toList();
        
        emit(NoticiaLoaded(
          noticias: noticiasActualizadas,
          hasMore: currentState.hasMore,
          currentPage: currentState.currentPage,
          lastUpdated: DateTime.now(),
        ));
      } catch (e) {
        if (e is ApiException) {
          emit(NoticiaError('Error al actualizar noticia: ${e.message}', statusCode: e.statusCode));
          // Restaurar el estado anterior
          emit(currentState);
        } else {
          emit(NoticiaError('Error al actualizar noticia: ${e.toString()}'));
          // Restaurar el estado anterior
          emit(currentState);
        }
      }
    }
  }

  Future<void> _onDelete(NoticiaDeleteEvent event, Emitter<NoticiaState> emit) async {
    final currentState = state;
    if (currentState is NoticiaLoaded) {
      try {
        await noticiaRepository.deleteNoticia(event.id);
        
        // Actualizar la lista de noticias
        final noticiasActualizadas = currentState.noticias.where((noticia) => noticia.id != event.id).toList();
        
        emit(NoticiaLoaded(
          noticias: noticiasActualizadas,
          hasMore: currentState.hasMore,
          currentPage: currentState.currentPage,
          lastUpdated: DateTime.now(),
        ));
      } catch (e) {
        if (e is ApiException) {
          emit(NoticiaError('Error al eliminar noticia: ${e.message}', statusCode: e.statusCode));
          // Restaurar el estado anterior
          emit(currentState);
        } else {
          emit(NoticiaError('Error al eliminar noticia: ${e.toString()}'));
          // Restaurar el estado anterior
          emit(currentState);
        }
      }
    }
  }
}