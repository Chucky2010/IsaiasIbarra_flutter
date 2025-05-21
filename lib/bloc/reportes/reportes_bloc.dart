import 'package:mi_proyecto/exceptions/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_proyecto/bloc/reportes/reportes_event.dart';
import 'package:mi_proyecto/bloc/reportes/reportes_state.dart';
import 'package:mi_proyecto/data/reporte_repository.dart';
import 'package:watch_it/watch_it.dart';

class ReporteBloc extends Bloc<ReporteEvent, ReporteState> {
  final ReporteRepository reporteRepository = di<ReporteRepository>();

  ReporteBloc() : super(ReporteInitial()) {
    on<ReporteInitEvent>(_onInit);
    on<ReporteCreateEvent>(_onCreateReporte);
    on<ReporteDeleteEvent>(_onDeleteReporte);
    on<ReporteGetByNoticiaEvent>(_onGetByNoticia);
    on<GetNumeroReportesEvent>(_onGetNumeroReportes);
  }

  Future<void> _onInit(ReporteInitEvent event, Emitter<ReporteState> emit) async {
    emit(ReporteLoading());

    try {
      final reportes = await reporteRepository.obtenerReportes();
      emit(ReporteLoaded(reportes, DateTime.now()));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(ReporteError('Error al cargar reportes: ${e.toString()}', statusCode: statusCode));
    }
  }  Future<void> _onCreateReporte(ReporteCreateEvent event, Emitter<ReporteState> emit) async {
    emit(ReporteLoading());

    try {
      final reporte = await reporteRepository.crearReporte(
        noticiaId: event.noticiaId,
        motivo: event.motivo,
      );
      emit(ReporteCreated(reporte!));

      // Recargar la lista después de crear
      final reportes = await reporteRepository.obtenerReportes();
      // Emitimos el estado de lista cargada primero
      emit(ReporteLoaded(reportes, DateTime.now()));
      
      // Obtener el número actualizado de reportes para esta noticia
      final int numeroReportesActualizado = await reporteRepository.obtenerTotalReportesPorNoticia(event.noticiaId);
      
      // Emitir el estado con el contador actualizado como último estado para asegurar que sea capturado por NoticiaCard
      emit(NumeroReportesLoaded(
        numeroReportes: numeroReportesActualizado,
        noticiaId: event.noticiaId,
      ));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(ReporteError('Error al crear reporte: ${e.toString()}', statusCode: statusCode));
    }
  }

  Future<void> _onDeleteReporte(ReporteDeleteEvent event, Emitter<ReporteState> emit) async {
    emit(ReporteLoading());

    try {
      await reporteRepository.eliminarReporte(event.id);
      emit(ReporteDeleted(event.id));

      // Recargar la lista después de eliminar
      final reportes = await reporteRepository.obtenerReportes();
      emit(ReporteLoaded(reportes, DateTime.now()));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(ReporteError('Error al eliminar reporte: ${e.toString()}', statusCode: statusCode));
    }
  }

  Future<void> _onGetByNoticia(ReporteGetByNoticiaEvent event, Emitter<ReporteState> emit) async {
    emit(ReporteLoading());

    try {
      final reportes = await reporteRepository.obtenerReportesPorNoticia(event.noticiaId);
      emit(ReportesPorNoticiaLoaded(reportes, event.noticiaId));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(ReporteError('Error al obtener reportes por noticia: ${e.toString()}', statusCode: statusCode));
    }
  }

  Future<void> _onGetNumeroReportes(GetNumeroReportesEvent event, Emitter<ReporteState> emit) async {
    try {
      final int numeroReportes = await reporteRepository.obtenerTotalReportesPorNoticia(event.noticiaId);
      emit(NumeroReportesLoaded(numeroReportes: numeroReportes, noticiaId: event.noticiaId));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(ReporteError('Error al obtener número de reportes: ${e.toString()}', statusCode: statusCode));
    }
  }
}