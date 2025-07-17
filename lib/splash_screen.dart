import 'dart:async';
import 'package:flutter/material.dart';
import 'package:matrimonial_app/features/home_module/view/home_screen.dart';
import 'package:matrimonial_app/utils/app_constants.dart';
import 'package:matrimonial_app/utils/preferences.dart';
import 'on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }


  Future<void> _initializePreferences() async {
    var token = Preferences.getString(AppConstants.token, defaultValue: "");
    Timer(Duration(seconds: 3), () {
      if (token.isNotEmpty) {
        Navigator.pushReplacement(
          context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else { // Handle no token case
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        ); // Handle no token case
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [

          Image.asset(
            'assets/images/spalsh.png',
            fit: BoxFit.cover,
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo (2).png',
                  height: 80,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
