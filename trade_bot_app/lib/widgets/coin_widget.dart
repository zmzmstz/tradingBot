import 'package:flutter/material.dart';

class CoinWidget extends StatelessWidget {
  final Map<String, dynamic> coin;

  const CoinWidget({required this.coin});

  @override
  Widget build(BuildContext context) {
    final symbol = coin['s']; // Coin sembolü
    final price = double.tryParse(coin['c']) ?? 0.0; // Şu anki fiyat
    final change = double.tryParse(coin['P']) ?? 0.0; // Değişim yüzdesi

    return ListTile(
      leading: CircleAvatar(
        child: Text(symbol.substring(0, 1)),
      ),
      title: Text(symbol),
      subtitle: Text('\$${price.toStringAsFixed(2)}'),
      trailing: Text(
        '${change.toStringAsFixed(2)}%',
        style: TextStyle(
          color: change > 0 ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
