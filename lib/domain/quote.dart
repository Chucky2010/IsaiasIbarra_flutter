class Quote {
  final String companyName;
  final double stockPrice;
  final double changePercentage;
  final DateTime lastUpdated; // Nueva propiedad para la última actualización

  Quote({
    required this.companyName,
    required this.stockPrice,
    required this.changePercentage,
    required this.lastUpdated, // Inicialización requerida
  });
}