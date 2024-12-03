import 'package:flutter/material.dart';
import '../../repositories/user_repository.dart';
import '../../models/user_model.dart';

class PortfolioScreen extends StatefulWidget {
  final UserRepository userRepository;
  final String username;

  const PortfolioScreen({
    required this.userRepository,
    required this.username,
  });

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  User? user; // Kullanıcı bilgisi
  bool isLoading = true; // Yüklenme durumu

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
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı verileri alınamadı: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (user == null) {
      return Center(
        child: Text('Kullanıcı bilgisi yüklenemedi.'),
      );
    }

    final coins = user!.coins;

    return Scaffold(
      appBar: AppBar(
        title: Text('Portfolio'),
      ),
      body: coins.isEmpty
          ? Center(
              child: Text(
                'No coins in portfolio.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: coins.length,
              itemBuilder: (context, index) {
                final coin = coins[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(coin.symbol[0]), // Coin'in ilk harfi
                    ),
                    title: Text(coin.symbol),
                    subtitle: Text(
                        'Amount: ${coin.amount.toStringAsFixed(2)}'), // Coin miktarı
                  ),
                );
              },
            ),
    );
  }
}
