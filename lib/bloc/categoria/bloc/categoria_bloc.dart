import 'package:bloc/bloc.dart';
 import 'package:mi_proyecto/bloc/categoria/bloc/categoria_event.dart';
 import 'package:mi_proyecto/bloc/categoria/bloc/categoria_state.dart';
 import 'package:mi_proyecto/data/categoria_repository.dart';
 import 'package:watch_it/watch_it.dart';
 
 
 class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
   final CategoriaRepository categoriaRepository = di<CategoriaRepository>();
 
   CategoriaBloc() : super(CategoriaInitial()) {
     on<CategoriaInitEvent>(_onInit);
     on<CategoriaCreateEvent>(_onCreate);
     on<CategoriaUpdateEvent>(_onUpdate);
     on<CategoriaDeleteEvent>(_onDelete);
   }
 
   Future<void> _onInit(CategoriaInitEvent event, Emitter<CategoriaState> emit) async {
     emit(CategoriaLoading());
 
     try {
       final categorias = await categoriaRepository.getCategorias();
       emit(CategoriaLoaded(categorias, DateTime.now()));
     } catch (e) {
       emit(CategoriaError('Failed to load categories: ${e.toString()}'));
     }
   }
 
   /// Método auxiliar para gestionar operaciones de categoría y manejo de errores
   Future<void> _ejecutarOperacionCategoria({
     required Emitter<CategoriaState> emit,
     required Future<void> Function() operacion,
     required String mensajeError,
   }) async {
     final currentState = state;
     
     emit(CategoriaLoading());
     
     try {
       await operacion();
       final categorias = await categoriaRepository.getCategorias();
       emit(CategoriaLoaded(categorias, DateTime.now()));
     } catch (e) {
       emit(CategoriaError('$mensajeError: ${e.toString()}'));
       if (currentState is CategoriaLoaded) {
         emit(currentState);
       }
     }
   }
   
   Future<void> _onCreate(CategoriaCreateEvent event, Emitter<CategoriaState> emit) async {
     await _ejecutarOperacionCategoria(
       emit: emit,
       operacion: () => categoriaRepository.crearCategoria(event.categoria),
       mensajeError: 'Error al crear la categoría',
     );
   }
   
   Future<void> _onUpdate(CategoriaUpdateEvent event, Emitter<CategoriaState> emit) async {
     await _ejecutarOperacionCategoria(
       emit: emit,
       operacion: () => categoriaRepository.actualizarCategoria(event.id, event.categoria),
       mensajeError: 'Error al actualizar la categoría',
     );
   }
   
   Future<void> _onDelete(CategoriaDeleteEvent event, Emitter<CategoriaState> emit) async {
     await _ejecutarOperacionCategoria(
       emit: emit,
       operacion: () => categoriaRepository.eliminarCategoria(event.id),
       mensajeError: 'Error al eliminar la categoría',
     );
   }
 }
