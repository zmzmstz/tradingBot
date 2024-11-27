import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/coin_model.dart';
import '../../repositories/coin_repository.dart';
import 'coin_event.dart';
import 'coin_state.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  final CoinRepository coinRepository;

  CoinBloc(this.coinRepository) : super(CoinInitialState()) {
    on<FetchCoinsEvent>(_onFetchCoins);
  }

  Future<void> _onFetchCoins(FetchCoinsEvent event, Emitter<CoinState> emit) async {
    emit(CoinLoadingState());
    try {
      final coins = await coinRepository.fetchCoins(event.symbols);
      emit(CoinLoadedState(coins: coins));
    } catch (e) {
      emit(CoinErrorState(message: 'Failed to fetch coins: $e'));
    }
  }
}
