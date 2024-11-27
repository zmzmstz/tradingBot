class Coin {
  final String symbol;
  final double priceChangePercent;
  final double lastPrice;

  Coin({
    required this.symbol,
    required this.priceChangePercent,
    required this.lastPrice,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      symbol: json['symbol'] ?? '',
      priceChangePercent: double.tryParse(json['priceChangePercent'] ?? '0') ?? 0.0,
      lastPrice: double.tryParse(json['lastPrice'] ?? '0') ?? 0.0,
    );
  }
}
