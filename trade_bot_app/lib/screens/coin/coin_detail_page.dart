import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'buy_sell_page.dart';
import '../../repositories/user_repository.dart';

class CoinDetailPage extends StatelessWidget {
  final Map<String, dynamic> coin; // Coin bilgisi
  final UserRepository userRepository = UserRepository(); // Kullanıcı verilerini yöneten repository
  final String username; // Kullanıcı adı

  CoinDetailPage({
    required this.coin,
    required this.username,
  });

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
            SizedBox(height: 32),
            Text(
              'Price Chart (24h)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        10,
                        (index) => FlSpot(index.toDouble(), (index * 10 + 5).toDouble()),
                      ),
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuySellPage(
                          coin: coin,
                          action: 'Buy',
                          userRepository: userRepository,
                          username: username,
                        ),
                      ),
                    );
                  },
                  child: Text('Buy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuySellPage(
                          coin: coin,
                          action: 'Sell',
                          userRepository: userRepository,
                          username: username,
                        ),
                      ),
                    );
                  },
                  child: Text('Sell'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
