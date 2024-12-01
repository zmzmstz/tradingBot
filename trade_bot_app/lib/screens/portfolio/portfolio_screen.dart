import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/portfolio/portfolio_bloc.dart';
import '../../blocs/portfolio/portfolio_event.dart';
import '../../blocs/portfolio/portfolio_state.dart';
import '../../repositories/portfolio_repository.dart';

class PortfolioScreen extends StatelessWidget {
  final PortfolioRepository portfolioRepository = PortfolioRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PortfolioBloc(portfolioRepository: portfolioRepository),
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Portfolio'),
        ),
        body: BlocBuilder<PortfolioBloc, PortfolioState>(
          builder: (context, state) {
            if (state is PortfolioInitialState) {
              // Başlangıç durumu
              context.read<PortfolioBloc>().add(LoadPortfolioEvent());
              return Center(child: CircularProgressIndicator());
            } else if (state is PortfolioLoadedState) {
              // Portföy yüklendi
              double totalValue = state.portfolioList.fold(0, (sum, coin) {
                return sum + (coin.quantity * coin.price);
              });

              return Column(
                children: [
                  Text('Portfolio Value: \$${totalValue.toStringAsFixed(2)}'),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.portfolioList.length,
                      itemBuilder: (context, index) {
                        final coin = state.portfolioList[index];
                        double coinValue = coin.quantity * coin.price;
                        return ListTile(
                          title: Text(coin.symbol),
                          subtitle: Text('Quantity: ${coin.quantity}'),
                          trailing: Text('\$${coinValue.toStringAsFixed(2)}'),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is PortfolioErrorState) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
