import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class BinanceWebSocketService {
  final List<String> symbols;
  late final List<WebSocketChannel> _channels;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  bool _isClosed = false;

  BinanceWebSocketService({required this.symbols}) {
    _channels = symbols.map((s) {
      final stream = '${s.toLowerCase()}@ticker';
      final url = 'wss://stream.binance.com:9443/ws/$stream';
      final channel = WebSocketChannel.connect(Uri.parse(url));

      // Listen to the stream
      channel.stream.listen(
        (message) {
          if (!_isClosed) {
            final data = jsonDecode(message);
            final symbol = data['s']; // Coin symbol
            _controller.add({symbol: data});
          }
        },
        onError: (error) {
          if (!_isClosed) {
            _controller.addError(error);
          }
        },
        onDone: () {
          if (!_isClosed) {
            _controller.close();
          }
        },
      );

      return channel;
    }).toList();
  }

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void close() {
    if (!_isClosed) {
      _isClosed = true;
      for (var channel in _channels) {
        channel.sink.close();
      }
      _controller.close();
    }
  }
}
