import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../repositories/user_repository.dart';
import 'buy_sell_page.dart';

class CoinDetailPage extends StatefulWidget {
  final Map<String, dynamic> coin; // Coin bilgisi
  final String username; // Kullanıcı adı

  CoinDetailPage({required this.coin, required this.username});

  @override
  _CoinDetailPageState createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage> {
  final UserRepository userRepository = UserRepository();
  List<FlSpot> priceSpots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPriceData();
  }

  Future<void> _fetchPriceData() async {
    try {
      const interval = '1h'; // 1 saatlik veri
      final symbol = widget.coin['s']; // Coin sembolü
      final response = await http.get(
        Uri.parse(
            'https://api.binance.com/api/v3/klines?symbol=$symbol&interval=$interval&limit=24'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // FlSpot noktalarını oluştur
        final List<FlSpot> spots = data.asMap().entries.map((entry) {
          final index = entry.key.toDouble(); // Zaman ekseni
          final closingPrice = double.parse(entry.value[4]); // Kapanış fiyatı
          return FlSpot(index, closingPrice);
        }).toList();

        setState(() {
          priceSpots = spots;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch price data');
      }
    } catch (e) {
      print('Error fetching price data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin['s']), // Coin sembolü
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Symbol: ${widget.coin['s']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Current Price: \$${widget.coin['c']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Price Change: ${widget.coin['P']}%',
              style: TextStyle(
                fontSize: 18,
                color: double.tryParse(widget.coin['P'])! > 0
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Price Chart (Last 24h)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: priceSpots,
                            isCurved: true,
                            dotData: FlDotData(show: false),
                            color: Colors.blue,
                          ),
                        ],
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                        ),
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: true),
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
                          coin: widget.coin,
                          action: 'Buy',
                          userRepository: userRepository,
                          username: widget.username,
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
                          coin: widget.coin,
                          action: 'Sell',
                          userRepository: userRepository,
                          username: widget.username,
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
