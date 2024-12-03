import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../data/users.dart';

class BotRepository {
  final Map<String, dynamic> botSettings = {
    'interval': 1, // Botun çalışacağı süre (dakika)
    'indicators': [], // Seçilen indikatörler
    'symbol': 'BTCUSDT', // İşlem görecek sembol
    'tradingAmount': 0.1, // Alım/Satım miktarı
    'rsiThreshold': 30, // RSI eşiği
    'macdThreshold': 0, // MACD eşiği
  };

  final StreamController<String> _botStreamController =
      StreamController<String>.broadcast();

  Stream<String> get botStream => _botStreamController.stream;

  void dispose() {
    _botStreamController.close();
  }

  void setIndicators(List<String> indicators) {
    botSettings['indicators'] = indicators;
    print('Indicators updated: $indicators');
  }

  Future<void> runBot(String username) async {
    final user = users.firstWhere(
      (user) => user['username'] == username,
      orElse: () => {},
    );

    if (user == null) {
      _botStreamController.add('User not found!');
      return;
    }

    final endTime =
        DateTime.now().add(Duration(minutes: botSettings['interval']));

    while (DateTime.now().isBefore(endTime)) {
      try {
        final price = await getPrice();
        final indicatorValues = await fetchIndicators();

        final action = decisionToTrade(indicatorValues, price);

        if (action != null) {
          _botStreamController.add(
              '$action signal detected for BTCUSDT at \$${price.toStringAsFixed(2)}');
          await executeTrade(user, action, price);
        } else {
          _botStreamController.add('No trade signal detected.');
        }

        await Future.delayed(Duration(seconds: 5));
      } catch (e) {
        _botStreamController.add('Error: $e');
      }
    }

    _botStreamController.add('Bot operation completed.');
  }

  Future<double> getPrice() async {
    // Gerçek zamanlı BTC fiyatını çekmek için bir API kullanın
    final response = await http.get(
      Uri.parse('https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return double.parse(data['price']);
    } else {
      throw Exception('Failed to fetch BTC price');
    }
  }

  Map<String, dynamic>? getUser(String username) {
    try {
      // Kullanıcı adı eşleşen ilk kullanıcıyı bul
      return users.firstWhere(
        (user) => user['username'] == username,
        orElse: () => {}, // Kullanıcı bulunamazsa null döndür
      );
    } catch (e) {
      print('Error fetching user: $e');
      return null; // Hata durumunda null döndür
    }
  }

  Future<Map<String, dynamic>> fetchIndicators() async {
    const symbol = 'BTCUSDT'; // BTC üzerinden çalışacak
    const interval = '1h'; // Saatlik veri

    try {
      // 1. Binance API'den fiyat verilerini al (OHLC)
      final priceResponse = await http.get(
        Uri.parse(
            'https://api.binance.com/api/v3/klines?symbol=$symbol&interval=$interval&limit=100'),
      );

      if (priceResponse.statusCode != 200) {
        throw Exception('Failed to fetch price data');
      }

      // Gelen veriyi işleyin
      final priceData =
          List<List<dynamic>>.from(jsonDecode(priceResponse.body));

      // Fiyat verilerini çıkart
      final closePrices =
          priceData.map((kline) => double.parse(kline[4])).toList();
      final highPrices =
          priceData.map((kline) => double.parse(kline[2])).toList();
      final lowPrices =
          priceData.map((kline) => double.parse(kline[3])).toList();

      // 2. RSI Hesaplama
      final rsi = calculateRSI(closePrices);

      // 3. SMA ve EMA Hesaplama
      final sma = calculateSMA(closePrices, 14); // SMA için 14 periyot
      final ema = calculateEMA(closePrices, 14); // EMA için 14 periyot

      // 4. Bollinger Bands Hesaplama
      final bollingerBands = calculateBollingerBands(closePrices);

      // 5. MACD Hesaplama
      final macd = calculateMACD(closePrices);

      // 6. SuperTrend Hesaplama (Hesaplama yapılabilir veya simüle edilebilir)
      final superTrend = calculateSuperTrend(closePrices);

      // 7. DMI Hesaplama (Directional Movement Index)
      final dmi = calculateDMI(closePrices, highPrices, lowPrices, 14);

      // Tüm indikatörleri bir Map olarak döndür
      return {
        'RSI': rsi,
        'MACD': macd,
        'DMI': dmi,
        'Bollinger Bands': bollingerBands,
        'SMA': sma,
        'EMA': ema,
        'SuperTrend': superTrend,
      };
    } catch (e) {
      throw Exception('Error fetching indicators: $e');
    }
  }

  String? decisionToTrade(Map<String, dynamic> indicators, double price) {
    // Seçili indikatörler
    final List<String> selectedIndicators = botSettings['indicators'];

    // RSI kontrolü
    if (selectedIndicators.contains('RSI') &&
        indicators.containsKey('RSI') &&
        indicators['RSI'] < botSettings['rsiThreshold']) {
      return 'BUY';
    }

    // MACD kontrolü
    if (selectedIndicators.contains('MACD') &&
        indicators.containsKey('MACD') &&
        indicators['MACD'] > botSettings['macdThreshold']) {
      return 'BUY';
    }

    // Bollinger Bands kontrolü
    if (selectedIndicators.contains('Bollinger Bands') &&
        indicators.containsKey('Bollinger Bands')) {
      final bollingerBands = indicators['Bollinger Bands'];
      if (price < bollingerBands['lower']) {
        return 'BUY';
      }
      if (price > bollingerBands['upper']) {
        return 'SELL';
      }
    }

    // SuperTrend kontrolü
    if (selectedIndicators.contains('SuperTrend') &&
        indicators.containsKey('SuperTrend') &&
        indicators['SuperTrend'] == 'DOWN') {
      return 'SELL';
    }

    // SMA kontrolü
    if (selectedIndicators.contains('SMA') &&
        indicators.containsKey('SMA') &&
        price < indicators['SMA']) {
      return 'BUY';
    }

    // EMA kontrolü
    if (selectedIndicators.contains('EMA') &&
        indicators.containsKey('EMA') &&
        price < indicators['EMA']) {
      return 'BUY';
    }

    // DMI kontrolü (+DI ve -DI farkı)
    if (selectedIndicators.contains('DMI') &&
        indicators.containsKey('+DI') &&
        indicators.containsKey('-DI')) {
      final plusDI = indicators['+DI'];
      final minusDI = indicators['-DI'];
      if (plusDI > minusDI) {
        return 'BUY';
      } else if (minusDI > plusDI) {
        return 'SELL';
      }
    }

    // Eğer hiçbir sinyal bulunamazsa
    return null;
  }

  Future<void> executeTrade(
      Map<String, dynamic> user, String action, double price) async {
    final symbol = botSettings['symbol'];
    final amount = botSettings['tradingAmount'];
    final totalPrice = price * amount;

    if (action == 'BUY') {
      if (user['balance'] < totalPrice) {
        _botStreamController.add('Insufficient balance to execute BUY.');
        return;
      }
      user['balance'] -= totalPrice;

      final existingCoin = user['coins'].firstWhere(
        (coin) => coin['symbol'] == symbol,
        orElse: () => null,
      );

      if (existingCoin != null) {
        existingCoin['amount'] += amount;
      } else {
        user['coins'].add({'symbol': symbol, 'amount': amount});
      }

      user['history'].add({
        'action': 'BUY',
        'symbol': symbol,
        'amount': amount,
        'price': price,
        'date': DateTime.now().toIso8601String(),
      });

      _botStreamController.add(
          'BUY executed: $amount $symbol at \$${price.toStringAsFixed(2)}');
    } else if (action == 'SELL') {
      final existingCoin = user['coins'].firstWhere(
        (coin) => coin['symbol'] == symbol,
        orElse: () => null,
      );

      if (existingCoin == null || existingCoin['amount'] < amount) {
        _botStreamController.add('Insufficient coins to execute SELL.');
        return;
      }

      existingCoin['amount'] -= amount;

      if (existingCoin['amount'] == 0) {
        user['coins'].remove(existingCoin);
      }

      user['balance'] += totalPrice;

      user['history'].add({
        'action': 'SELL',
        'symbol': symbol,
        'amount': amount,
        'price': price,
        'date': DateTime.now().toIso8601String(),
      });

      _botStreamController.add(
          'SELL executed: $amount $symbol at \$${price.toStringAsFixed(2)}');
    }
  }

  double calculateRSI(List<double> prices, {int period = 14}) {
    List<double> gains = [];
    List<double> losses = [];

    for (int i = 1; i < prices.length; i++) {
      final change = prices[i] - prices[i - 1];
      if (change > 0) {
        gains.add(change);
        losses.add(0);
      } else {
        losses.add(-change);
        gains.add(0);
      }
    }

    final avgGain = gains.take(period).reduce((a, b) => a + b) / period;
    final avgLoss = losses.take(period).reduce((a, b) => a + b) / period;

    final rs = avgGain / avgLoss;
    return 100 - (100 / (1 + rs));
  }

  double calculateSMA(List<double> prices, int period) {
    if (prices.length < period) return 0.0;

    final recentPrices = prices.sublist(prices.length - period);
    return recentPrices.reduce((a, b) => a + b) / period;
  }

  double calculateEMA(List<double> prices, int period) {
    if (prices.length < period) return 0.0;

    final double k = 2 / (period + 1);
    double ema = prices.sublist(0, period).reduce((a, b) => a + b) / period;

    for (int i = period; i < prices.length; i++) {
      ema = prices[i] * k + ema * (1 - k);
    }

    return ema;
  }

  Map<String, double> calculateBollingerBands(List<double> prices,
      {int period = 20}) {
    if (prices.length < period) return {'upper': 0.0, 'lower': 0.0};

    final sma = calculateSMA(prices, period);
    final squaredDiffs = prices.sublist(prices.length - period).map((price) {
      final diff = price - sma;
      return diff * diff;
    }).toList();

    final variance = squaredDiffs.reduce((a, b) => a + b) / period;
    final stddev = sqrt(variance);

    return {'upper': sma + (2 * stddev), 'lower': sma - (2 * stddev)};
  }

  double calculateMACD(List<double> prices,
      {int shortPeriod = 12, int longPeriod = 26, int signalPeriod = 9}) {
    final shortEMA = calculateEMA(prices, shortPeriod);
    final longEMA = calculateEMA(prices, longPeriod);
    final macd = shortEMA - longEMA;

    // Signal Line için
    final signalLine = calculateEMA([macd], signalPeriod);

    return macd - signalLine;
  }

  String calculateSuperTrend(List<double> prices) {
    // Daha gelişmiş hesaplama için özel algoritmalar veya kütüphaneler kullanılabilir.
    // Şimdilik simüle edilmiş UP/DOWN trendi döndürüyoruz.
    return Random().nextBool() ? 'UP' : 'DOWN';
  }

  Map<String, double> calculateDMI(List<double> closePrices,
      List<double> highPrices, List<double> lowPrices, int period) {
    if (closePrices.length < period ||
        highPrices.length < period ||
        lowPrices.length < period) {
      return {'+DI': 0.0, '-DI': 0.0, 'ADX': 0.0};
    }

    List<double> trList = [];
    List<double> plusDMList = [];
    List<double> minusDMList = [];

    for (int i = 1; i < closePrices.length; i++) {
      final highDiff = highPrices[i] - highPrices[i - 1];
      final lowDiff = lowPrices[i - 1] - lowPrices[i];

      final trueRange = [
        (highPrices[i] - lowPrices[i]).abs(),
        (highPrices[i] - closePrices[i - 1]).abs(),
        (lowPrices[i] - closePrices[i - 1]).abs(),
      ].reduce((a, b) => a > b ? a : b);

      trList.add(trueRange);

      plusDMList.add((highDiff > lowDiff && highDiff > 0) ? highDiff : 0.0);
      minusDMList.add((lowDiff > highDiff && lowDiff > 0) ? lowDiff : 0.0);
    }

    // Average True Range (ATR) Hesaplama
    final atrList = calculateEMA(trList, period);

    // +DI ve -DI Hesaplama
    final plusDI = (plusDMList.reduce((a, b) => a + b) / atrList) * 100;
    final minusDI = (minusDMList.reduce((a, b) => a + b) / atrList) * 100;

    // DX Hesaplama
    final dx = ((plusDI - minusDI).abs() / (plusDI + minusDI)) * 100;

    // ADX Hesaplama (DX'in EMA'sı)
    final adx = calculateEMA([dx], period);

    return {'+DI': plusDI, '-DI': minusDI, 'ADX': adx};
  }
}
