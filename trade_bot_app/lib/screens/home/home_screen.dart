import 'package:flutter/material.dart';
import '../../services/websocket_service.dart';
import '../coin/coin_detail_page.dart';
import '../../widgets/coin_widget.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToIndicators;
  final String username;

  const HomeScreen({
    required this.onNavigateToIndicators,
    required this.username,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BinanceWebSocketService _webSocketService;
  final Map<String, dynamic> _coinData = {};

  @override
  void initState() {
    super.initState();
    _webSocketService = BinanceWebSocketService(
      symbols: [
        'BTCUSDT',
        'ETHUSDT',
        'BNBUSDT',
        'ADAUSDT',
        'SOLUSDT',
        'XRPUSDT',
        'DOTUSDT',
        'LTCUSDT',
        'DOGEUSDT',
        'MATICUSDT',
      ],
    );

    // Coin verilerini toplamak için dinleyici
    _webSocketService.stream.listen((data) {
      setState(() {
        _coinData.addAll(data); // Gelen coin verisini birleştir
      });
    });
  }

  @override
  void dispose() {
    _webSocketService.close();
    super.dispose();
  }

  Widget _buildTopCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome ${widget.username},',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Find the most effective indicators',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: widget.onNavigateToIndicators,
                      child: Text('Choose Indicators'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coins = _coinData.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Trending Coins'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopCard(context), // Üstteki kart
          Expanded(
            child: coins.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: coins.length,
                    itemBuilder: (context, index) {
                      final coin = coins[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CoinDetailPage(
                                coin: coin,
                                username: widget.username,
                              ),
                            ),
                          );
                        },
                        child: CoinWidget(coin: coin),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
