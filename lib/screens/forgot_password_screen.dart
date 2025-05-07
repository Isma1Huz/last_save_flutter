import 'package:flutter/material.dart';
import 'package:last_save/screens/otp_verification_screen.dart';
import 'package:last_save/utils/app_theme.dart';
import 'package:last_save/widgets/app_button.dart';
import 'package:last_save/widgets/app_layout.dart';
import 'package:last_save/widgets/app_text_field.dart';

/// ForgotPasswordScreen allows users to request a password reset
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

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isLoading = false;
      });

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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading
                const SectionTitle(
                  title: 'Forgot Password?',
                ),
                const VerticalSpace(height: 8),
                const SectionSubtitle(
                  text:
                      "Don't worry! It occurs. Please enter the email address linked with your account.",
                ),
                const VerticalSpace(height: 32),

                // Email field
                AppEmailField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                ),
                const VerticalSpace(height: 24),

                // Send code button
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
    );
  }
}
