import 'package:equatable/equatable.dart';

class TareaContadorState extends Equatable {
  final int completadas;
  final int total;

  const TareaContadorState({
    this.completadas = 0,
    this.total = 0,
  });

  double get porcentajeCompletado => 
      total == 0 ? 0.0 : completadas / total;

  TareaContadorState copyWith({
    int? completadas,
    int? total,
  }) {
    return TareaContadorState(
      completadas: completadas ?? this.completadas,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [completadas, total];
}