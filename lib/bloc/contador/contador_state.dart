import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ContadorStatus { initial, loading, loaded, error }

class ContadorState extends Equatable {
  final int valor;
  final ContadorStatus status;
  final String? errorMessage;

  const ContadorState({
    this.valor = 0,
    this.status = ContadorStatus.initial,
    this.errorMessage,
  });

  String get mensaje {
    if (valor > 0) {
      return 'Contador en positivo';
    } else if (valor == 0) {
      return 'Contador en cero';
    } else {
      return 'Contador en negativo';
    }
  }

  Color get colorMensaje {
    if (valor > 0) {
      return Colors.green;
    } else if (valor == 0) {
      return Colors.grey;
    } else {
      return Colors.red;
    }
  }

  ContadorState copyWith({
    int? valor,
    ContadorStatus? status,
    String? errorMessage,
  }) {
    return ContadorState(
      valor: valor ?? this.valor,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [valor, status, errorMessage];
}