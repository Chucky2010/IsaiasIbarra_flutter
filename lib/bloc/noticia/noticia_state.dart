import 'package:equatable/equatable.dart';
import 'package:mi_proyecto/domain/noticia.dart';

abstract class NoticiaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoticiaInitial extends NoticiaState {}

class NoticiaLoading extends NoticiaState {}

class NoticiaLoaded extends NoticiaState {
  final List<Noticia> noticias;
  final bool hasMore;
  final int currentPage;
  final DateTime lastUpdated;

  NoticiaLoaded({
    required this.noticias,
    required this.hasMore,
    required this.currentPage,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [noticias, hasMore, currentPage, lastUpdated];

  NoticiaLoaded copyWith({
    List<Noticia>? noticias,
    bool? hasMore,
    int? currentPage,
    DateTime? lastUpdated,
  }) {
    return NoticiaLoaded(
      noticias: noticias ?? this.noticias,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class NoticiaError extends NoticiaState {
  final String message;
  final int? statusCode;

  NoticiaError(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}