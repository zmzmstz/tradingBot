import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class BinanceWebSocketService {
  final List<String> symbols;
  late final WebSocketChannel _channel;
  final _controller = StreamController<Map<String, dynamic>>();

  BinanceWebSocketService({required this.symbols}) {
    final streams = symbols.map((s) => '${s.toLowerCase()}@ticker').join('/');
    final url = 'wss://stream.binance.com:9443/ws/$streams';
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel.stream.listen(
      (message) {
        final data = jsonDecode(message);
        final symbol = data['s']; // Coin sembolü
        _controller.add({symbol: data});
      },
      onError: (error) {
        _controller.addError(error);
      },
      onDone: () {
        _controller.close();
      },
    );
  }

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void close() {
    _channel.sink.close();
    _controller.close();
  }
}
