import 'dart:async';
import 'package:ecom/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecom App',
      initialRoute: AppRoutes.splash, // Set initial route to Splash
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

// Splash Screen
class Splash3 extends StatefulWidget {
  const Splash3({Key? key}) : super(key: key);

  @override
  _Splash3State createState() => _Splash3State();
}

class _Splash3State extends State<Splash3> {
  @override
  void initState() {
    super.initState();
    // Set up a 3-second timer to navigate to the Login page
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.login); // Use named route
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/welcome.json'), // Ensure the JSON file is in the assets
          ],
        ),
      ),
    );
  }
}
