import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 10), (){
      // Navigator.pushReplacementNamed(context, '/home');
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Positioned(top: -180, right: -180, child: Image.asset('lib/assets/images/circle_transparant.png', width: 450),),
        Positioned(top: 20, right: MediaQuery.of(context).size.width / 2 - 225, child: Image.asset('lib/assets/images/circle.png', width: 450),),
        const Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Z TRADE',
            style: TextStyle(
              fontSize: 32,
              color: Colors.black,
            ),
            ),
            SizedBox(height: 10,),
            Text('Improve your trading skills',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            ),
          ],)
        )
      ],)
    );
  }
}