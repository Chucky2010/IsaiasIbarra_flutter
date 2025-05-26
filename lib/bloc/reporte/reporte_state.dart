import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mi_proyecto/domain/noticia.dart';
import 'package:mi_proyecto/domain/reporte.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

@immutable
abstract class ReporteState extends Equatable {
  const ReporteState();
  
  @override
  List<Object?> get props => [];
}

class ReporteInitial extends ReporteState {}

class ReporteLoading extends ReporteState {
  final MotivoReporte? motivoActual;
  
  const ReporteLoading({this.motivoActual});
  
  @override
  List<Object?> get props => [motivoActual];
}

class ReporteSuccess extends ReporteState {
  final String mensaje;
  
  const ReporteSuccess({required this.mensaje});
  
  @override
  List<Object?> get props => [mensaje];
}

class ReporteError extends ReporteState {
  final ApiException error;
  
  const ReporteError(this.error);  
  @override
  List<Object?> get props => [error];
}

class ReporteEstadisticasLoaded extends ReporteState {
  final Noticia noticia;
  final Map<MotivoReporte, int> estadisticas;
  
  const ReporteEstadisticasLoaded({
    required this.noticia,
    required this.estadisticas,
  });
  
  @override
  List<Object?> get props => [noticia, estadisticas];
}

class NoticiaReportesActualizada extends ReporteState {
  final Noticia noticia;
  final int contadorReportes;
  
  const NoticiaReportesActualizada({
    required this.noticia,
    required this.contadorReportes,
  });
  
  @override
  List<Object?> get props => [noticia, contadorReportes];
}