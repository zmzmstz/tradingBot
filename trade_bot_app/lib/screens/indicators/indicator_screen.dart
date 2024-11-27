import 'package:flutter/material.dart';

class IndicatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Indicators'),
      ),
      body: Center(
        child: Text(
          'Here you can choose indicators!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
