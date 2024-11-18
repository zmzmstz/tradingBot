import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), (){
      Navigator.pushReplacementNamed(context, '/home');
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Positioned(top: -160, right: -180, child: Image.asset('lib/assets/images/circle_transparant.png', width: 450),),
        Positioned(top: 20, right: MediaQuery.of(context).size.width / 2 - 225, child: Image.asset('lib/assets/images/circle.png', width: 450),),
        Positioned(bottom: 80, left: -180, child: Image.asset('lib/assets/images/circle_transparant.png', width: 450),),
        Positioned(bottom: -80, right: -220, child: Image.asset('lib/assets/images/circle_transparant.png', width: 450),),
        Positioned(bottom: -260, left: -100, child: Image.asset('lib/assets/images/circle_transparant.png', width: 450),),
        const Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 340,),
            Text('Z TRADE',
            style: TextStyle(
              fontSize: 36,
              color: Colors.black87,
                fontWeight: FontWeight.w400,
            ),
            ),
            CircularProgressIndicator.adaptive(),
            SizedBox(height: 20,),
             Spacer(),
                Text(
                  'Improve your trading skills',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 100,
            ),
          ],)
        )
      ],)
    );
  }
}