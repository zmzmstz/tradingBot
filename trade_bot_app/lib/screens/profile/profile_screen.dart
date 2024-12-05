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
        title: Text('$username\'s Profile'),
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
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expanded user card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Username:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            state.user.username,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Balance:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '\$${state.user.balance.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Coins',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: state.user.coins.isEmpty
                          ? Text(
                              'No coins available',
                              style: TextStyle(color: Colors.grey),
                            )
                          : Column(
                              children: state.user.coins.map((coin) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blueAccent,
                                    child: Text(
                                      coin.symbol[0],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    coin.symbol,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'Amount: ${coin.amount.toStringAsFixed(4)}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Trade History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: state.user.history.isEmpty
                          ? Text(
                              'No trade history available',
                              style: TextStyle(color: Colors.grey),
                            )
                          : Column(
                              children: state.user.history.map((history) {
                                return ListTile(
                                  leading: Icon(
                                    history.action == 'BUY'
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: history.action == 'BUY'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  title: Text(
                                    '${history.action} ${history.symbol}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'Amount: ${history.amount.toStringAsFixed(2)} at \$${history.price.toStringAsFixed(2)}',
                                  ),
                                  trailing: Text(
                                    '${history.date}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
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
