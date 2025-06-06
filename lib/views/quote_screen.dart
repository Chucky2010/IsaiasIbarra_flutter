import 'package:flutter/material.dart';
import 'package:mi_proyecto/api/service/quote_service.dart';
import 'package:mi_proyecto/components/side_menu.dart';
import 'package:mi_proyecto/domain/quote.dart';
import 'package:mi_proyecto/constants/constantes.dart';
import 'package:intl/intl.dart'; // Importa el paquete intl

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  QuoteScreenState createState() => QuoteScreenState();
}

class QuoteScreenState extends State<QuoteScreen> {
  final QuoteService _quoteService = QuoteService();
  final ScrollController _scrollController = ScrollController();

  List<Quote> _quotes = [];
  int _pageNumber = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  static const double spacingHeight = 10; // Espaciado entre Cards
  @override
  void initState() {
    super.initState();
    _loadInitialQuotes(); // Carga las cotizaciones iniciales
    _scrollController.addListener(_onScroll);
  }
    // Método separado para el listener del scroll, más fácil de mantener
  void _onScroll() {
    if (!mounted) return; // Verificamos si el widget está montado
    
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && 
        !_isLoading && 
        _hasMore) {
      _loadQuotes();
    }
  }
  
  Future<void> _loadInitialQuotes() async {
    // Verificar si el widget está montado antes de actualizar el estado
    if (!mounted) return;
    
    // Usamos un bloque try para manejar cualquier error que ocurra al actualizar el estado
    try {
      setState(() {
        _isLoading = true;
      });
    } catch (e) {
      // Si ocurre un error al llamar setState, probablemente el widget ya no esté montado
      return;
    }

    try {
      // Carga todas las cotizaciones disponibles
      final allQuotes = await _quoteService.getAllQuotes();
      
      // Verificar nuevamente si el widget está montado después de la operación asíncrona
      if (!mounted) return;
      
      // Usamos otro bloque try para asegurar que la operación sea segura
      try {
        setState(() {
          _quotes = allQuotes;
          _pageNumber = 1; // Configura la paginación para el scroll infinito
          _hasMore = allQuotes.isNotEmpty;
        });
      } catch (e) {
        // Si falla este setState, simplemente retornamos
        return;
      }
    } catch (e) {
      if (mounted) {
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(CotizacionConstantes.errorMessage)),
          );
        } catch (_) {
          // Ignorar errores al mostrar el SnackBar
        }
      }
    } finally {
      // Verificar si el widget está montado antes de actualizar el estado
      if (mounted) {
        try {
          setState(() {
            _isLoading = false;
          });
        } catch (_) {
          // Ignorar errores al actualizar el estado
        }
      }
    }
  }  Future<void> _loadQuotes() async {
    // Verificar si el widget está montado antes de actualizar el estado
    if (!mounted) return;
    
    // Usar un bloque try-catch para manejar posibles errores al llamar setState
    try {
      setState(() {
        _isLoading = true;
      });
    } catch (e) {
      // Si ocurre un error al actualizar el estado, probablemente el widget ya no está montado
      return;
    }

    try {
      final newQuotes = await _quoteService.getPaginatedQuotes(pageNumber: _pageNumber, pageSize: 5);
      
      // Verificar nuevamente si el widget está montado después de la operación asíncrona
      if (!mounted) return;
      
      // Usar otro bloque try-catch para actualizar el estado de forma segura
      try {
        setState(() {
          _quotes.addAll(newQuotes);
          _pageNumber++;
          _hasMore = newQuotes.isNotEmpty;
        });
      } catch (e) {
        // Si falla el setState, simplemente retornamos
        return;
      }
    } catch (e) {
      // Verificar si el widget está montado antes de mostrar el mensaje de error
      if (mounted) {
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(CotizacionConstantes.errorMessage)),
          );
        } catch (_) {
          // Ignorar errores al mostrar el SnackBar
        }
      }     
    } finally {
      // Verificar si el widget está montado antes de actualizar el estado final
      if (mounted) {
        try {
          setState(() {
            _isLoading = false;
          });
        } catch (_) {
          // Ignorar errores al actualizar el estado
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          CotizacionConstantes.titleApp,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      drawer: const SideMenu(),
      backgroundColor: colorScheme.brightness == Brightness.dark 
          ? colorScheme.surface 
          : Colors.grey[200], // Respeta el modo oscuro
      body: _quotes.isEmpty && _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    CotizacionConstantes.loadingMessage,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : _quotes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 48,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay cotizaciones disponibles',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _quotes.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _quotes.length) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                            strokeWidth: 3,
                          ),
                        ),
                      );
                    }

                    final quote = _quotes[index];
                    return Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            // Usar un borde para mejorar visibilidad en modo oscuro
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: colorScheme.brightness == Brightness.dark
                                    ? colorScheme.outline
                                    : Colors.transparent,
                              ),
                            ),
                            elevation: colorScheme.brightness == Brightness.dark ? 0.5 : 1,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    quote.companyName,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Precio: \$${quote.stockPrice.toStringAsFixed(2)}',
                                    style: textTheme.bodyMedium,
                                  ),
                                  Text(
                                    'Cambio: ${quote.changePercentage.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: quote.changePercentage >= 0 
                                        ? Colors.green.shade700 
                                        : Colors.red.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Última actualización: ${_formatDate(quote.lastUpdated)}',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.brightness == Brightness.dark
                                          ? colorScheme.onSurface
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: spacingHeight), // Espaciado entre Cards
                      ],
                    );
                  },
                ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat(AppConstantes.formatoFecha).format(date);
  }
}