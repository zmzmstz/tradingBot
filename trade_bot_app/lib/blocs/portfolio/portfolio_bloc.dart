// portfolio_bloc.dart
import 'package:bloc/bloc.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';
import '../../models/portfolio_model.dart';  // Portfolio modelini import et
import '../../repositories/portfolio_repository.dart'; // Portfolio repository'sini import et

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final PortfolioRepository portfolioRepository;

  PortfolioBloc({required this.portfolioRepository}) : super(PortfolioInitialState());

  @override
  Stream<PortfolioState> mapEventToState(PortfolioEvent event) async* {
    if (event is LoadPortfolioEvent) {
      try {
        // Portföyü yükle
        final portfolioList = portfolioRepository.getPortfolio();
        yield PortfolioLoadedState(portfolioList: portfolioList);
      } catch (e) {
        yield PortfolioErrorState(message: e.toString());
      }
    } else if (event is UpdatePortfolioEvent) {
      try {
        // Alım/Satım işlemi sonrası portföyü güncelle
        final updatedPortfolioList = portfolioRepository.updatePortfolio(event.updatedPortfolio);
        yield PortfolioLoadedState(portfolioList: updatedPortfolioList);
      } catch (e) {
        yield PortfolioErrorState(message: e.toString());
      }
    }
  }
}
