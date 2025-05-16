import 'package:flutter/material.dart';
import 'package:last_save/screens/otp_verification_screen.dart';
import 'package:last_save/widgets/ui/app_button.dart';
import 'package:last_save/widgets/layout/app_layout.dart';
import 'package:last_save/widgets/ui/app_text_field.dart';
import 'package:last_save/services/firebase_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseService.sendPasswordResetEmail(_emailController.text.trim());
        
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationScreen(
                email: _emailController.text,
              ),
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
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                  title: 'Forgot Password?',
                ),
                const VerticalSpace(height: 8),
                const SectionSubtitle(
                  text:
                      "Don't worry! It occurs. Please enter the email address linked with your account.",
                ),
                const VerticalSpace(height: 32),

                AppEmailField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                ),
                const VerticalSpace(height: 24),

                AppButton(
                    text: _isLoading ? 'Sending...' : 'Send Code',
                    onPressed: () {
                        if (!_isLoading) {
                        _sendCode();
                        }
                    },
                    ),

              ],
            ),
          ),
        ),
      ),
      )

    );
  }
}
