import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/main_screen.dart';
import 'screens/splash_screen.dart'; // Splash Screen'i ekledik

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Başlangıç rotası
      routes: {
        '/': (context) => SplashScreen(), // Splash Screen başlangıç ekranı
        '/home': (context) => MainScreen(), // Splash sonrası ana ekran
      },
    );
  }
}
