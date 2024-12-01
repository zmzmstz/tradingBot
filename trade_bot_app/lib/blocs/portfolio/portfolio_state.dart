// portfolio_state.dart
import '../../models/portfolio_model.dart';

abstract class PortfolioState {}

class PortfolioInitialState extends PortfolioState {}

class PortfolioLoadedState extends PortfolioState {
  final List<Portfolio> portfolioList;

  PortfolioLoadedState({required this.portfolioList});
}

class PortfolioErrorState extends PortfolioState {
  final String message;

  PortfolioErrorState({required this.message});
}
