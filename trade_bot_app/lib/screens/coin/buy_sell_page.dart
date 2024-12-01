import 'package:flutter/material.dart';

class BuySellPage extends StatefulWidget {
  final Map<String, dynamic> coin;
  final String action; // 'Buy' veya 'Sell'

  const BuySellPage({required this.coin, required this.action});

  @override
  _BuySellPageState createState() => _BuySellPageState();
}

class _BuySellPageState extends State<BuySellPage> {
  final TextEditingController _amountController = TextEditingController();
  double _total = 0.0;
  String _errorMessage = '';
  
  double userBalance = 10000.0; // Kullanıcının bakiyesi (sahte veri)
  double coinQuantityInPortfolio = 5.0; // Kullanıcının portföydeki coin miktarı (sahte veri)

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

  void _performTransaction() {
    final amount = double.tryParse(_amountController.text) ?? 0;

    // Alış işlemi
    if (widget.action == 'Buy') {
      if (amount * double.parse(widget.coin['c']) > userBalance) {
        // Yeterli bakiye yok
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yeterli bakiyeniz yok!')),
        );
      } else {
        setState(() {
          userBalance -= amount * double.parse(widget.coin['c']);
          coinQuantityInPortfolio += amount;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Alış işlemi başarıyla tamamlandı!')),
        );
      }
    }

    // Satış işlemi
    if (widget.action == 'Sell') {
      if (amount > coinQuantityInPortfolio) {
        // Yeterli coin yok
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yeterli coin miktarınız yok!')),
        );
      } else {
        setState(() {
          userBalance += amount * double.parse(widget.coin['c']);
          coinQuantityInPortfolio -= amount;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Satış işlemi başarıyla tamamlandı!')),
        );
      }
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
              'Your Balance: \$${userBalance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              'Coins in Portfolio: ${coinQuantityInPortfolio.toStringAsFixed(2)} ${widget.coin['s']}',
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
