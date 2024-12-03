import 'coin_model.dart';
import 'trade_history_model.dart';

class User {
  final String username;
  double balance;
  List<Coin> coins;
  List<TradeHistory> history;

  User({
    required this.username,
    required this.balance,
    required this.coins,
    required this.history,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      balance: json['balance'].toDouble(),
      coins: (json['coins'] as List)
          .map((coin) => Coin.fromJson(coin))
          .toList(),
      history: (json['history'] as List)
          .map((history) => TradeHistory.fromJson(history))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'balance': balance,
      'coins': coins.map((coin) => coin.toJson()).toList(),
      'history': history.map((history) => history.toJson()).toList(),
    };
  }
}
