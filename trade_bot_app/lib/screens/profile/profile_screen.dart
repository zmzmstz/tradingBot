import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../repositories/user_repository.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  final UserRepository userRepository;
  final String username;

  ProfileScreen({required this.username, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$username Profile Screen'),
      ),
      body: BlocProvider(
        create: (context) => ProfileBloc(
          userRepository: userRepository,
        )..add(LoadProfile(username: username)),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username: ${state.user.username}',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Balance: \$${state.user.balance.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Coins:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (state.user.coins.isEmpty)
                      Text('No coins available'),
                    ...state.user.coins.map((coin) {
                      return Text('${coin.symbol}: ${coin.amount}');
                    }).toList(),
                    SizedBox(height: 10),
                    Text(
                      'Trade History:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (state.user.history.isEmpty)
                      Text('No trade history available'),
                    ...state.user.history.map((history) {
                      return Text(
                        '${history.action} ${history.symbol} ${history.amount} at \$${history.price} on ${history.date}',
                      );
                    }).toList(),
                  ],
                ),
              );
            } else if (state is ProfileError) {
              return Center(
                child: Text(
                  'Error: ${state.error}',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
