import 'package:flutter/material.dart';
import 'package:mi_proyecto/api/services/quote_service.dart';
import 'package:mi_proyecto/domain/quote.dart';
import 'package:mi_proyecto/constants.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final QuoteService _quoteService = QuoteService();
  final List<Quote> _quotes = [];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final double spacingHeight = 10; // Espaciado entre Cards


  @override
  void initState() {
    super.initState();
    _loadQuotes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading && _hasMore) {
        _loadQuotes();
      }
    });
  }

 Future<void> _loadQuotes() async {
  if (_isLoading || !_hasMore) return;

  setState(() {
    _isLoading = true;
  });

  try {
    // Llama al servicio para obtener cotizaciones paginadas
    final List<Quote> newQuotes = await _quoteService.getPaginatedQuotes(pageNumber: _currentPage);

    setState(() {
      if (newQuotes.isEmpty) {
        _hasMore = false; // No hay más cotizaciones
      } else {
        _quotes.addAll(newQuotes);
        _currentPage++;
      }
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(errorMessage),
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
        title: const Text(titleApp),
      ),
      body: Container(
      color: Colors.grey[200], // Fondo gris claro
       child: _quotes.isEmpty && !_isLoading
          ? const Center(
              child: Text(
                emptyList,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: _quotes.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _quotes.length) {
                  // Muestra un indicador de carga al final de la lista
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final quote = _quotes[index];
                return Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text(quote.companyName),
                        subtitle: Text('Precio: \$${quote.stockPrice.toStringAsFixed(2)}'),
                        trailing: Text(
                          '${quote.changePercentage > 0 ? '+' : ''}${quote.changePercentage.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: quote.changePercentage > 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: spacingHeight), // Espaciado entre Cards
                  ],
                );
                
              },
            ),
      ),
    );
  }
}


