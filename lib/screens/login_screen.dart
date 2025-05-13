// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:last_save/screens/forgot_password_screen.dart';
import 'package:last_save/screens/register_screen.dart';
import 'package:last_save/utils/app_theme.dart';
import 'package:last_save/utils/form_validators.dart';
import 'package:last_save/widgets/ui/app_button.dart';
import 'package:last_save/widgets/layout/app_layout.dart';
import 'package:last_save/widgets/ui/app_text_field.dart';
import 'package:last_save/widgets/ui/social_login_button.dart';
import 'package:last_save/screens/home_screen.dart';
import 'package:last_save/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      
      try {
        await FirebaseService.signInWithEmailPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Incorect email or password"),
            backgroundColor: Colors.red,
          ),
          ); 
                  
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      await FirebaseService.signInWithGoogle();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google login successful!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (error) {
      if (mounted && error.toString() != 'Sign in aborted by user') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: 'Welcome back! Glad\nto see you. Again!',
              ),
              const VerticalSpace(height: 32),
              
              AppEmailField(
                controller: _emailController,
                hintText: 'Enter your email',
              ),
              const VerticalSpace(),
              
              AppPasswordField(
                controller: _passwordController,
                hintText: 'Enter your password',
                validator: FormValidators.password,
              ),                    
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
              
              AppButton(
                text: 'Login',
                onPressed: _login,
                isLoading: _isLoading,
              ),
              const VerticalSpace(height: 24),
              
              const DividerWithText(text: 'Or Login with'),
              const VerticalSpace(height: 24),
              
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
                    onPressed: _signInWithGoogle,
                  ),
                  SocialLoginButton(
                    iconData: Icons.apple,
                    color: Colors.black,
                    onPressed: () {},
                  ),
                ],
              ),
              const VerticalSpace(height: 32),
              
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
      ),
    );
  }
}