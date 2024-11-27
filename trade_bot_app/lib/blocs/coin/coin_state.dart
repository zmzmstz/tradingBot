import '../../models/coin_model.dart';

abstract class CoinState {}

class CoinInitialState extends CoinState {}

class CoinLoadingState extends CoinState {}

class CoinLoadedState extends CoinState {
  final List<Coin> coins;

  CoinLoadedState({required this.coins});
}

class CoinErrorState extends CoinState {
  final String message;

  CoinErrorState({required this.message});
}
