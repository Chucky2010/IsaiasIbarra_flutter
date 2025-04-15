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
  late Future<List<Quote>> _futureQuotes;

  @override
  void initState() {
    super.initState();
    _futureQuotes = _quoteService.getQuotes(); // Obtiene las cotizaciones al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(titleApp),
      ),
      body: FutureBuilder<List<Quote>>(
        future: _futureQuotes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), // Muestra un indicador de carga
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'), // Muestra el error si ocurre
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(emptyList), // Muestra un mensaje si no hay cotizaciones
            );
          } else {
            final quotes = snapshot.data!;
            return ListView.builder(
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                final quote = quotes[index];
                return Card(
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
                );
              },
            );
          }
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:mi_proyecto/api/services/quote_service.dart';
// import 'package:mi_proyecto/domain/quote.dart';
// import 'package:mi_proyecto/constants.dart';

// class QuoteScreen extends StatefulWidget {
//   const QuoteScreen({super.key});

//   @override
//   State<QuoteScreen> createState() => _QuoteScreenState();
// }

// class _QuoteScreenState extends State<QuoteScreen> {
//   final QuoteService _quoteService = QuoteService();
//   final List<Quote> _quotes = [];
//   int _currentPage = 1;
//   bool _isLoading = false;
//   bool _hasMore = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadQuotes();
//   }

//   Future<void> _loadQuotes() async {
//     if (_isLoading || !_hasMore) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final List<Quote> newQuotes = await _quoteService.getPaginatedQuotes(pageNumber: _currentPage);

//       setState(() {
//         if (newQuotes.isEmpty) {
//           _hasMore = false; // No hay más cotizaciones
//         } else {
//           _quotes.addAll(newQuotes);
//           _currentPage++;
//         }
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error al cargar las cotizaciones: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(titleApp),
//       ),
//       body: _quotes.isEmpty && !_isLoading
//           ? const Center(
//               child: Text(
//                 emptyList,
//                 style: TextStyle(fontSize: 16),
//               ),
//             )
//           : ListView.builder(
//               itemCount: _quotes.length + (_hasMore ? 1 : 0),
//               itemBuilder: (context, index) {
//                 if (index == _quotes.length) {
//                   // Muestra un indicador de carga al final de la lista
//                   return const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: CircularProgressIndicator(),
//                     ),
//                   );
//                 }

//                 final quote = _quotes[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                   child: ListTile(
//                     title: Text(quote.companyName),
//                     subtitle: Text('Precio: \$${quote.stockPrice.toStringAsFixed(2)}'),
//                     trailing: Text(
//                       '${quote.changePercentage > 0 ? '+' : ''}${quote.changePercentage.toStringAsFixed(2)}%',
//                       style: TextStyle(
//                         color: quote.changePercentage > 0 ? Colors.green : Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//               controller: ScrollController()
//                 ..addListener(() {
//                   if (_isLoading) return;
//                   final controller = ScrollController();
//                   if (controller.position.pixels == controller.position.maxScrollExtent) {
//                     _loadQuotes();
//                   }
//                 }),
//             ),
//     );
//   }
// }


