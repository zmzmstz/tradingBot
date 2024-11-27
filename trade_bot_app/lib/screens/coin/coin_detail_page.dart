import 'package:flutter/material.dart';

class CoinDetailPage extends StatelessWidget {
  final Map<String, dynamic> coin; // Coin bilgisi

  const CoinDetailPage({required this.coin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(coin['s']), // Coin sembolü
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Symbol: ${coin['s']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Current Price: \$${coin['c']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Price Change: ${coin['P']}%',
              style: TextStyle(
                fontSize: 18,
                color: double.tryParse(coin['P'])! > 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
