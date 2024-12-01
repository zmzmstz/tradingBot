// portfolio_repository.dart
import '../models/portfolio_model.dart';

class PortfolioRepository {
  List<Portfolio> portfolio = [
    Portfolio(symbol: 'BTC', quantity: 2, price: 45000),
    Portfolio(symbol: 'ETH', quantity: 5, price: 3000),
  ];

  List<Portfolio> getPortfolio() {
    return portfolio;
  }

  List<Portfolio> updatePortfolio(Portfolio updatedPortfolio) {
    // Mevcut portföydeki coini güncelle
    final index = portfolio.indexWhere((coin) => coin.symbol == updatedPortfolio.symbol);
    if (index != -1) {
      portfolio[index] = updatedPortfolio;
    } else {
      portfolio.add(updatedPortfolio);
    }
    return portfolio;
  }
}
