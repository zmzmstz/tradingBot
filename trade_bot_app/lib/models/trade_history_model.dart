class TradeHistory {
  final String action;
  final String symbol;
  final double amount;
  final double price;
  final DateTime date;

  TradeHistory({
    required this.action,
    required this.symbol,
    required this.amount,
    required this.price,
    required this.date,
  });

  factory TradeHistory.fromJson(Map<String, dynamic> json) {
    return TradeHistory(
      action: json['action'],
      symbol: json['symbol'],
      amount: json['amount'].toDouble(),
      price: json['price'].toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'symbol': symbol,
      'amount': amount,
      'price': price,
      'date': date.toIso8601String(),
    };
  }
}
