import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'landing_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LandingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 80,
          ),
          Column(
            children: [
              Text(
                'Welcome !',
                style: TextStyle(
                  fontSize: 35,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Smart Payments,\nconsectetur adipiscing elit'),
            ],
          ),
          Image.asset('assets/logo.png'),
          SpinKitCircle(
            color: Colors.blue,
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
