// portfolio_event.dart
import '../../models/portfolio_model.dart';

abstract class PortfolioEvent {}

class LoadPortfolioEvent extends PortfolioEvent {}

class UpdatePortfolioEvent extends PortfolioEvent {
  final Portfolio updatedPortfolio;

  UpdatePortfolioEvent({required this.updatedPortfolio});
}
