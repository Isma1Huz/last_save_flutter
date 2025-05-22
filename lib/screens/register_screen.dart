import 'package:flutter/material.dart';
import 'package:last_save/screens/login_screen.dart';
import 'package:last_save/screens/onboarding_screen.dart';
import 'package:last_save/utils/form_validators.dart';
import 'package:last_save/widgets/ui/app_button.dart';
import 'package:last_save/widgets/layout/app_layout.dart';
import 'package:last_save/widgets/ui/app_text_field.dart';
import 'package:last_save/widgets/ui/social_login_button.dart';
import 'package:last_save/services/firebase_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await FirebaseService.registerWithEmailPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );
        
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OnboardingScreen(),
            ),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _registerWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      await FirebaseService.signInWithGoogle();
      
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
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
    return  Scaffold(
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
              const SectionTitle(title: 'Hello! Register to get\nstarted'),
              const VerticalSpace(height: 16),

              AppTextField(
                controller: _usernameController,
                hintText: 'Username',
                validator: FormValidators.required,
              ),
              const VerticalSpace(),

              AppEmailField(controller: _emailController),
              const VerticalSpace(),

              AppPasswordField(
                controller: _passwordController,
                hintText: 'Password',
                validator: FormValidators.password,
              ),
              const VerticalSpace(),

              AppPasswordField(
                controller: _confirmPasswordController,
                hintText: 'Confirm password',
                validator: (value) =>
                    FormValidators.confirmPassword(value, _passwordController.text),
              ),
              const VerticalSpace(height: 24),

              AppButton(
                text: 'Register',
                onPressed: _register,
                isLoading: _isLoading,
              ),
              const VerticalSpace(height: 24),

              const DividerWithText(text: 'Or Register with'),
              const VerticalSpace(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialLoginButton(
                    iconData: Icons.facebook,
                    color: Colors.blue,
                    onPressed: (){},
                  ),
                  SocialLoginButton(
                    customIcon: Image.asset(
                      'assets/images/google.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                    onPressed: _registerWithGoogle,
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
                    const Text('Already have an account?'),
                    AppTextButton(
                      text: 'Login here',
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
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