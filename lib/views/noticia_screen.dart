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

  List<Noticia> _noticias = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadNoticias();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading && _hasMore) {
        _loadNoticias();
      }
    });
  }

  Future<void> _loadNoticias() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final noticias = await _noticiaService.getPaginatedNoticias(
        pageNumber: _currentPage,
        pageSize: Constants.tamanoPaginaConst,
      );

      setState(() {
        if (noticias.isEmpty) {
          _hasMore = false;
        } else {
          _noticias.addAll(noticias);
          _currentPage++;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${Constants.mensajeError}: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
      ),
      body: Container(
        color: Colors.grey[200], // Fondo gris claro
        child: _noticias.isEmpty && !_isLoading
            ? const Center(
                child: Text(
                  Constants.mensajeCargando, // Muestra mensajeCargando mientras se cargan las noticias
                  style: TextStyle(fontSize: 16),
                ),
              )
              : _noticias.isEmpty
              ? const Center(
                  child: Text(
                    Constants.listaVacia, // Muestra listaVacia si no hay datos
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
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagen aleatoria
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0), // Bordes redondeados para la imagen
                                  child: Image.network(
                                    noticia.imageUrl,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                      );
                                    },
                                  ),
                                ),
                          // Título en negrita
                          Text(
                            noticia.titulo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Descripción (máximo 3 líneas)
                          Text(
                            noticia.descripcion,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Fuente en cursiva
                          Text(
                            noticia.fuente,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Fecha de publicación en formato dd/MM/yyyy HH:mm
                          Text(
                            'Publicado: ${DateFormat(Constants.formatoFecha).format(noticia.publicadaEl)}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Constants.espaciadoAlto), // Espaciado entre Cards
                ]
            );
                },
              ),
      ),
    );
  }
}