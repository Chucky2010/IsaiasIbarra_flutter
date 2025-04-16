class Quote {
  final String companyName;
  final double stockPrice;
  final double changePercentage;
  final DateTime lastUpdated;  // Fecha y hora de la última actualización

  Quote({
    required this.companyName,
    required this.stockPrice,
    required this.changePercentage,
    required this.lastUpdated,
  });

  String  getCompanyName() => companyName;
  double  getStockPrice() => stockPrice;
  double  getChangePercentage() => changePercentage;
  DateTime getLastUpdated() => lastUpdated; // Método para obtener la fecha de la última actualización
  
  String getFormattedLastUpdated() {
    return '${lastUpdated.day}/${lastUpdated.month}/${lastUpdated.year} ${lastUpdated.hour}:${lastUpdated.minute}'; // Formato de fecha y hora
  }

}