import 'package:equatable/equatable.dart';

abstract class CoinEvent extends Equatable {
  const CoinEvent();

  @override
  List<Object?> get props => [];
}

class FetchCoinsEvent extends CoinEvent {
  final List<String> symbols;

  FetchCoinsEvent(this.symbols);

  @override
  List<Object?> get props => [symbols];
}
