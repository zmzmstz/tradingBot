import 'package:flutter/material.dart';
import 'package:trade_bot_app/screens/portfolio/portfolio_screen.dart';
import 'package:trade_bot_app/screens/profile/profile_screen.dart';
import 'indicators/indicator_screen.dart';
import 'home/home_screen.dart';
import '../repositories/user_repository.dart';

class MainScreen extends StatefulWidget {
  final UserRepository userRepository = UserRepository();
  
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Ekranlar listesi
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onNavigateToIndicators: navigateToIndicators, username: 'testuser'),
      PortfolioScreen(userRepository: widget.userRepository, username: 'testuser',),
      IndicatorScreen(),
      ProfileScreen(username: 'testuser', userRepository: widget.userRepository),
    ];
  }

  // Indicators sayfasına yönlendirme
  void navigateToIndicators() {
    setState(() {
      _currentIndex = 2; // Indicators sekmesinin index'i
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue, // Seçili ikon rengi
        unselectedItemColor: Colors.grey, // Seçili olmayan ikon rengi
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart), label: 'Portfolio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), label: 'Indicators'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
