import 'package:flutter/material.dart';
import '../../repositories/bot_repository.dart';
import '../bot/bot_detail_page.dart';

class IndicatorScreen extends StatefulWidget {
  final BotRepository botRepository;
  final String username;

  IndicatorScreen({required this.botRepository, required this.username});

  @override
  _IndicatorScreenState createState() => _IndicatorScreenState();
}

class _IndicatorScreenState extends State<IndicatorScreen> {
  final List<String> indicators = [
    'Bollinger Bands',
    'RSI',
    'SMA',
    'EMA',
    'MACD',
    'SuperTrend',
    'DMI',
  ];

  final Set<String> selectedIndicators = {};
  bool isBotRunning = false;

  void _startBot() async {
    if (selectedIndicators.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one indicator.')),
      );
      return;
    }

    widget.botRepository.setIndicators(selectedIndicators.toList());
    setState(() {
      isBotRunning = true;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BotDetailPage(
          botRepository: widget.botRepository,
          username: widget.username,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Indicators')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: indicators.length,
              itemBuilder: (context, index) {
                final indicator = indicators[index];
                final isSelected = selectedIndicators.contains(indicator);

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(indicator),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedIndicators.add(indicator);
                          } else {
                            selectedIndicators.remove(indicator);
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: isBotRunning ? null : _startBot,
              child: Text('Start Bot'),
            ),
          ),
        ],
      ),
    );
  }
}
