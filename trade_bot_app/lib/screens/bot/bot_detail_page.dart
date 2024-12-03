import 'package:flutter/material.dart';
import '../../repositories/bot_repository.dart';

class BotDetailPage extends StatefulWidget {
  final BotRepository botRepository;
  final String username;

  BotDetailPage({required this.botRepository, required this.username});

  @override
  _BotDetailPageState createState() => _BotDetailPageState();
}

class _BotDetailPageState extends State<BotDetailPage> {
  List<String> alerts = [];
  List<Map<String, dynamic>> tradeHistory = [];
  String? currentAction;

  @override
  void initState() {
    super.initState();

    widget.botRepository.botStream.listen((message) {
      setState(() {
        alerts.add(message);
        if (message.contains('BUY')) {
          currentAction = 'BUY';
        } else if (message.contains('SELL')) {
          currentAction = 'SELL';
        }
      });
    });

    final user = widget.botRepository.getUser(widget.username);
    if (user != null) {
      tradeHistory = List<Map<String, dynamic>>.from(user['history']);
    }

    widget.botRepository.runBot(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bot Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Bot Status:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              currentAction != null
                  ? 'Active Action: $currentAction'
                  : 'No active action',
              style: TextStyle(
                fontSize: 16,
                color: currentAction == 'BUY'
                    ? Colors.green
                    : currentAction == 'SELL'
                        ? Colors.red
                        : Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Alerts:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      alerts[index].contains('BUY')
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: alerts[index].contains('BUY')
                          ? Colors.green
                          : Colors.red,
                    ),
                    title: Text(alerts[index]),
                  );
                },
              ),
            ),
            Divider(),
            Text(
              'Trade History:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tradeHistory.length,
                itemBuilder: (context, index) {
                  final trade = tradeHistory[index];
                  return ListTile(
                    leading: Icon(
                      trade['action'] == 'BUY'
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: trade['action'] == 'BUY' ? Colors.green : Colors.red,
                    ),
                    title: Text(
                        '${trade['action']} ${trade['amount']} ${trade['symbol']}'),
                    subtitle: Text(
                        'Price: \$${trade['price']} on ${trade['date']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
