import 'package:equatable/equatable.dart';
import 'package:mi_proyecto/exceptions/api_exception.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final ApiException error;

  const AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}