import 'package:equatable/equatable.dart';
import 'package:mi_proyecto/domain/noticia.dart';
import 'package:mi_proyecto/domain/reporte.dart';

abstract class ReporteEvent extends Equatable {
  const ReporteEvent();

  @override
  List<Object?> get props => [];
}

class EnviarReporte extends ReporteEvent {
  final Noticia noticia;
  final MotivoReporte motivo;

  const EnviarReporte({
    required this.noticia,
    required this.motivo,
  });

  @override
  List<Object?> get props => [noticia, motivo];
}

class ActualizarContadorNoticia extends ReporteEvent {
  final Noticia noticia;
  final Map<MotivoReporte, int> estadisticas;

  const ActualizarContadorNoticia({
    required this.noticia,
    required this.estadisticas,
  });

  @override
  List<Object?> get props => [noticia, estadisticas];
}

class CargarEstadisticasReporte extends ReporteEvent {
  final Noticia noticia;

  const CargarEstadisticasReporte({required this.noticia});

  @override
  List<Object?> get props => [noticia];
}