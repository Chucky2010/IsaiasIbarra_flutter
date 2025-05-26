import 'package:equatable/equatable.dart';

abstract class ContadorEvent extends Equatable {
  const ContadorEvent();

  @override
  List<Object?> get props => [];
}

class ContadorIncrementEvent extends ContadorEvent {}

class ContadorDecrementEvent extends ContadorEvent {}

class ContadorResetEvent extends ContadorEvent {}