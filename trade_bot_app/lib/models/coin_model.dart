class Coin {
  final String symbol;
  double amount;

  Coin({
    required this.symbol,
    required this.amount,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      symbol: json['symbol'],
      amount: json['amount'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'amount': amount,
    };
  }
}
