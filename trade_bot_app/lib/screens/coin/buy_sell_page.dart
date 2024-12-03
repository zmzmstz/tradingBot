import 'package:flutter/material.dart';
import '../../models/coin_model.dart';
import '../../repositories/user_repository.dart';
import '../../models/user_model.dart'; // Kullanıcı modelini içe aktar

class BuySellPage extends StatefulWidget {
  final Map<String, dynamic> coin;
  final String action; // 'Buy' veya 'Sell'
  final UserRepository userRepository;
  final String username;

  const BuySellPage({
    required this.coin,
    required this.action,
    required this.userRepository,
    required this.username,
  });

  @override
  _BuySellPageState createState() => _BuySellPageState();
}

class _BuySellPageState extends State<BuySellPage> {
  final TextEditingController _amountController = TextEditingController();
  double _total = 0.0;
  String _errorMessage = '';
  User? user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final fetchedUser = await widget.userRepository.getUser(widget.username);
      setState(() {
        user = fetchedUser;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı verileri alınamadı: $e')),
      );
    }
  }

  void _calculateTotal() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      setState(() {
        _total = 0.0;
        _errorMessage = 'Lütfen geçerli bir miktar girin.';
      });
    } else {
      setState(() {
        _total = amount * double.parse(widget.coin['c']);
        _errorMessage = '';
      });
    }
  }

  Future<void> _performTransaction() async {
    if (user == null) return;

    final amount = double.tryParse(_amountController.text) ?? 0;
    final currentPrice = double.parse(widget.coin['c']); // Doğru fiyatı al

    try {
      if (widget.action == 'Buy') {
        // Alış işlemi
        await widget.userRepository.trade(
          username: widget.username,
          symbol: widget.coin['s'],
          amount: amount,
          action: 'BUY',
          currentPrice: currentPrice,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Alış işlemi başarıyla tamamlandı!')),
        );
      } else if (widget.action == 'Sell') {
        // Satış işlemi
        await widget.userRepository.trade(
          username: widget.username,
          symbol: widget.coin['s'],
          amount: amount,
          action: 'SELL',
          currentPrice: currentPrice,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Satış işlemi başarıyla tamamlandı!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İşlem başarısız: $e')),
      );
    }

    // Güncellenmiş kullanıcı verilerini al
    await _fetchUser();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.action} ${widget.coin['s']}'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.action} ${widget.coin['s']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Price: \$${widget.coin['c']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                errorText: _errorMessage.isEmpty ? null : _errorMessage,
              ),
              onChanged: (_) => _calculateTotal(),
            ),
            SizedBox(height: 16),
            Text(
              'Total: \$${_total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Your Balance: \$${user!.balance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              'Coins in Portfolio: ${user!.coins.firstWhere((coin) => coin.symbol == widget.coin['s'], orElse: () => Coin(symbol: widget.coin['s'], amount: 0.0)).amount} ${widget.coin['s']}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _total > 0 ? _performTransaction : null,
              child: Text('${widget.action} ${widget.coin['s']}'),
            ),
          ],
        ),
      ),
    );
  }
}
