import 'package:equatable/equatable.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

abstract class PreferenciaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PreferenciaInitial extends PreferenciaState {}

class PreferenciaLoading extends PreferenciaState {}

enum TipoOperacionPreferencia { cargar, guardar, reiniciar, cambiarCategoria }

class PreferenciaError extends PreferenciaState {
  final ApiException error;
  final TipoOperacionPreferencia tipoOperacion;

  PreferenciaError(
    this.error,
    this.tipoOperacion,
  );

  @override
  List<Object?> get props => [error, tipoOperacion];
}

// Estado base cuando las preferencias están cargadas
class PreferenciasLoaded extends PreferenciaState {
  final List<String> categoriasSeleccionadas;
  final DateTime? lastUpdated;

  PreferenciasLoaded({
    this.categoriasSeleccionadas = const [],
    this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    categoriasSeleccionadas,
    lastUpdated,
  ];
}

// Estado después de guardar preferencias con éxito
class PreferenciasSaved extends PreferenciasLoaded {
  PreferenciasSaved({
    required super.categoriasSeleccionadas,
    super.lastUpdated,
  });
}

// Estado después de resetear todos los filtros
class PreferenciasReset extends PreferenciasLoaded {
  PreferenciasReset({
    super.categoriasSeleccionadas = const [],
    super.lastUpdated,
  });
}
