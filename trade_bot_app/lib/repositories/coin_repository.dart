import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coin_model.dart';

class CoinRepository {
  final String apiKey;

  CoinRepository({required this.apiKey});

  Future<List<Coin>> fetchCoins(List<String> symbols) async {
    List<Coin> coins = [];
    for (String symbol in symbols) {
      final url = Uri.parse('https://api.binance.com/api/v3/ticker/24hr?symbol=$symbol');
      final response = await http.get(url, headers: {
        'X-MBX-APIKEY': apiKey,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        coins.add(Coin.fromJson(data));
      } else {
        throw Exception('Failed to fetch $symbol data');
      }
    }
    return coins;
  }
}
