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

  Widget _buildPortfolioSummary() {
    final totalBalance = user!.balance;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Portfolio Value',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '\$${totalBalance.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinList() {
    return ListView.builder(
      itemCount: user!.coins.length,
      itemBuilder: (context, index) {
        final coin = user!.coins[index];

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                coin.symbol[0],
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(coin.symbol),
            subtitle: Text(
              '${coin.amount.toStringAsFixed(4)} ${coin.symbol}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Portfolio'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Portfolio'),
        ),
        body: Center(
          child: Text('Kullanıcı bilgisi yüklenemedi.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Portfolio'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPortfolioSummary(), // Portföy özeti
          Expanded(child: _buildCoinList()), // Coin listesi
        ],
      ),
    );
  }
}
