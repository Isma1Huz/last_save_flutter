import 'package:flutter/material.dart';
import 'package:last_save/screens/forgot_password_screen.dart';
import 'package:last_save/screens/register_screen.dart';
import 'package:last_save/utils/app_theme.dart';
import 'package:last_save/utils/form_validators.dart';
import 'package:last_save/widgets/app_button.dart';
import 'package:last_save/widgets/app_layout.dart';
import 'package:last_save/widgets/app_text_field.dart';
import 'package:last_save/widgets/social_login_button.dart';
import 'package:last_save/screens/home_screen.dart';


/// LoginScreen allows users to sign in to their account
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
      }


      
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: 'Welcome back! Glad\nto see you. Again!',
            ),
            const VerticalSpace(height: 32),
            
            // Email field
            AppEmailField(
              controller: _emailController,
              hintText: 'Enter your email',
            ),
            const VerticalSpace(),
            
            // Password field
            AppPasswordField(
              controller: _passwordController,
              hintText: 'Enter your password',
              validator: FormValidators.password,
            ),
            
            // Forgot password link
            Align(
              alignment: Alignment.centerRight,
              child: AppTextButton(
                text: 'Forgot Password?',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  );
                },
              ),
            ),
            const VerticalSpace(height: 24),
            
            // Login 
            AppButton(
              text: 'Login',
              onPressed: _login,
              isLoading: _isLoading,
            ),
            const VerticalSpace(height: 24),
            
            // Or login with divider
            const DividerWithText(text: 'Or Login with'),
            const VerticalSpace(height: 24),
            
            // Social login buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                                SocialLoginButton(
                    iconData: Icons.facebook,
                    color: Colors.blue,
                    onPressed: () {},
                    ),
                SocialLoginButton(
                    customIcon: Image.asset(
                        'assets/images/google.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                    ),
                    onPressed: () {},
                ),
                SocialLoginButton(
                    iconData: Icons.apple,
                    color: Colors.black,
                    onPressed: () {},
                ),
              ],
            ),
            const VerticalSpace(height: 32),
            
            // Register link
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  AppTextButton(
                    text: 'Register Now',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}