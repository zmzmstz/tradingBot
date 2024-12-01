import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'blocs/coin/coin_bloc.dart';
import 'blocs/coin/coin_event.dart';
import 'repositories/coin_repository.dart';
import 'screens/main_screen.dart';
import 'screens/splash_screen.dart'; // Splash Screen'i ekledik

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final coinRepository = CoinRepository(apiKey: dotenv.env['BINANCE_API_KEY']!);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CoinBloc(coinRepository)
            ..add(
              FetchCoinsEvent(['BTCUSDT', 'ETHUSDT', 'ADAUSDT', 'BNBUSDT', 'XRPUSDT']), // Önemli coinler
            ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/', // Başlangıç rotası
        routes: {
          '/': (context) => SplashScreen(), // Splash Screen başlangıç ekranı
          '/home': (context) => MainScreen(), // Splash sonrası ana ekran
        },
      ),
    );
  }
}
