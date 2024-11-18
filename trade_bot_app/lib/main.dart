import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trade Bot App',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => Scaffold(body: Center(child: Text('HomeScreen'),),),
      },
    );
  }
}