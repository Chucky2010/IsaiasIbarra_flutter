import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mi_proyecto/api/services/noticia_service.dart';
import 'package:mi_proyecto/domain/noticia.dart';
import 'package:mi_proyecto/constants.dart';
import 'package:intl/intl.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});

  @override
  State<NoticiaScreen> createState() => _NoticiaScreenState();
}

class _NoticiaScreenState extends State<NoticiaScreen> {
  final NoticiaService _noticiaService = NoticiaService();
  final ScrollController _scrollController = ScrollController();

  final List<Noticia> _noticias = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _ordenarPorFecha = true;

  bool _hayError = false; // Estado para mostrar mensaje de error
  String _mensajeError = ''; // Mensaje de error

  DateTime? _ultimaActualizacion; // Estado para la última actualización

  @override
  void initState() {
    super.initState();
    _loadNoticias();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        _loadNoticias();
      }
    });
  }

  final Set<String> _noticiasIds = {}; // Almacena los IDs únicos de las noticias
  
  Future<void> _loadNoticias() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _hayError = false; // Reinicia el estado de error
    });

    try {
      final noticias = await _noticiaService.getPaginatedNoticias(
        pageNumber: _currentPage,
        pageSize: Constants.tamanoPaginaConst,
        ordenarPorFecha: _ordenarPorFecha, // Pasa el criterio de ordenamiento
      );

      setState(() {

        //  final nuevasNoticias = noticias.where((noticia) => !_noticiasIds.contains(noticia.id)).toList();
        // _noticiasIds.addAll(nuevasNoticias.map((noticia) => noticia.id));

       if (noticias.isEmpty) {
        _hasMore = false; // Detiene la paginación si se alcanza el límite
        } else {
          _noticias.addAll(noticias);
          _currentPage++;
        }
      _ultimaActualizacion = DateTime.now(); // Actualiza la fecha de la última actualización 
      });
    } catch (e) {
      setState(() {
        _hayError = true; // Activa el estado de error
        _mensajeError =
            '${Constants.mensajeError}: $e'; // Guarda el mensaje de error
      });

      // Muestra el SnackBar con el mensaje de error
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('${Constants.mensajeError}: $e'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.tituloApp),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: Constants.tooltipOrden,
            onPressed: () {
              setState(() {
                _ordenarPorFecha =
                    !_ordenarPorFecha; // Alterna el valor booleano
                _noticias.clear(); // Reinicia la lista de noticias
                _currentPage = 1; // Reinicia la paginación
                _hasMore = true; // Permite cargar más noticias
              });
              _loadNoticias(); // Carga las noticias nuevamente
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNoticias,
        child: Container(
          color: Colors.grey[200], // Fondo gris claro
          child: Column(
            children: [
              if (_ultimaActualizacion != null) // Muestra el texto solo si hay una fecha
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Última actualización: ${DateFormat(Constants.formatoFecha).format(_ultimaActualizacion!)}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              Expanded(
                child: _isLoading && _noticias.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(), // Muestra el loader
                      )
                    : _hayError
                        ? Center(
                            child: Text(
                              _mensajeError, // Muestra el mensaje de error
                              style: const TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          )
                        : _noticias.isEmpty
                            ? const Center(
                                child: Text(
                                  Constants.listaVacia, // Muestra lista vacía si no hay noticias
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                itemCount: _noticias.length + (_hasMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == _noticias.length) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  final noticia = _noticias[index];
                                  return Column(
                                    children: [
                                      Card(
                                        margin: EdgeInsets.zero,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(
                                                        26.0, 16.0, 16.0, 16.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          noticia.titulo,
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Text(
                                                          noticia.descripcion,
                                                          maxLines: 3,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Text(
                                                          noticia.fuente,
                                                          style: const TextStyle(
                                                            fontStyle: FontStyle.italic,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Text(
                                                          DateFormat(Constants.formatoFecha)
                                                              .format(noticia.publicadaEl),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(16.0),
                                                        child: Image.network(
                                                          noticia.imageUrl,
                                                          height: 80,
                                                          width: 120,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder: (context, child,
                                                              loadingProgress) {
                                                            if (loadingProgress == null) {
                                                              return child;
                                                            }
                                                            return const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            );
                                                          },
                                                          errorBuilder: (context, error,
                                                              stackTrace) {
                                                            return const Center(
                                                              child: Icon(
                                                                Icons.broken_image,
                                                                size: 50,
                                                                color: Colors.grey,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceAround,
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.favorite_border),
                                                          onPressed: () {
                                                            print('Favorito presionado');
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(Icons.share),
                                                          onPressed: () {
                               print('Compartir presionado');
                           },
                          ),
                           IconButton(
                                 icon: const Icon(Icons.more_vert),
                             onPressed: () {
                           print('Más opciones presionado');
                               },
                              ),
                             ],
                             ),
                           ],
                        ),
                         ],
                        ),
                        ],
                        ),
                      ),
                   ],
                   );
                  },
                 ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshNoticias() async {
    setState(() {
      _noticias.clear(); // Limpia la lista de noticias
      _currentPage = 1; // Reinicia la paginación
      _hasMore = true; // Permite cargar más noticias
      _hayError = false; // Reinicia el estado de error
    });

    await _loadNoticias(); // Recarga las noticias
    setState(() {
      _ultimaActualizacion =
          DateTime.now(); // Actualiza la fecha de la última actualización
    });
  }
}
