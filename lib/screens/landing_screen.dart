import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './BottomNavBar/bottom_nav_bar.dart';
import 'signInScreen.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return BottomNavBarScreen();
        }
        return SignInScreen();
      },
    );
  }
}
