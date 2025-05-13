import 'package:flutter/material.dart';
import 'package:last_save/screens/home_screen.dart';
import 'package:last_save/screens/welcome_screen.dart';
import 'package:last_save/services/firebase_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    await FirebaseService.initializeFirebase();
    
    await Future.delayed(const Duration(seconds: 2));
    
    // Check if user is authenticated
    final bool isAuthenticated = await FirebaseService.isAuthenticated();
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => isAuthenticated 
              ? const HomeScreen() 
              : const WelcomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}