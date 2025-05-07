import 'package:flutter/material.dart';
import 'package:last_save/screens/login_screen.dart';
import 'package:last_save/screens/register_screen.dart';
import 'package:last_save/utils/app_theme.dart';
import 'package:last_save/widgets/app_button.dart';
import 'package:last_save/widgets/app_layout.dart';

/// WelcomeScreen is the initial screen shown to users
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      scrollable: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Logo and app name
          Center(
            child: Column(
              children: [
                // App logo
                ClipOval(
                    child: Image.asset(
                    'assets/images/logo.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    ),
                ),
                const VerticalSpace(),
                // App name with styled text
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Last',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Save',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 32), // Space between logo and text
          AppButton(
            text: 'Login',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
          const VerticalSpace(),
          // Register button
          AppOutlinedButton(
            text: 'Register',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}