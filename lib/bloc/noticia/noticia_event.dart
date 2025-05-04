import 'package:equatable/equatable.dart';
import 'package:mi_proyecto/domain/noticia.dart';

abstract class NoticiaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoticiaInitEvent extends NoticiaEvent {}

class NoticiaRefreshEvent extends NoticiaEvent {}

class NoticiaLoadMoreEvent extends NoticiaEvent {}

class NoticiaCreateEvent extends NoticiaEvent {
  final Noticia noticia;

  NoticiaCreateEvent(this.noticia);

  @override
  List<Object?> get props => [noticia];
}

class NoticiaUpdateEvent extends NoticiaEvent {
  final Noticia noticia;

  NoticiaUpdateEvent(this.noticia);

  @override
  List<Object?> get props => [noticia];
}

class NoticiaDeleteEvent extends NoticiaEvent {
  final String id;

  NoticiaDeleteEvent(this.id);

  @override
  List<Object?> get props => [id];
}