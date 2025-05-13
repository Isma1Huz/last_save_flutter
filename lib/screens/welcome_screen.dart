import 'package:flutter/material.dart';
import 'package:last_save/screens/login_screen.dart';
import 'package:last_save/screens/register_screen.dart';
import 'package:last_save/utils/app_theme.dart';
import 'package:last_save/widgets/ui/app_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Image.asset(
                'assets/images/welkom.jpg',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),

            Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
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
                const SizedBox(height: 32),
                AppButton(
                  text: 'Login',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
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
          ],
        ),
      ),
    );
  }
}