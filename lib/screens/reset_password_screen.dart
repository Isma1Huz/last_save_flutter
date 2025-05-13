import 'package:flutter/material.dart';
import 'package:last_save/screens/password_changed_screen.dart';
import 'package:last_save/utils/form_validators.dart';
import 'package:last_save/widgets/ui/app_button.dart';
// import 'package:last_save/widgets/layout/app_layout.dart';
import 'package:last_save/widgets/ui/app_text_field.dart';
import 'package:last_save/services/firebase_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String resetCode;
  
  const ResetPasswordScreen({
    Key? key, 
    required this.email,
    required this.resetCode,
  }) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        await FirebaseService.confirmPasswordReset(
          widget.resetCode,
          _passwordController.text,
        );
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const PasswordChangedScreen(),
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
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView( 
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Create new password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8), 
                  const Text(
                    'Your new password must be unique from those previously used.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32), 
                  
                  AppPasswordField(
                    controller: _passwordController,
                    hintText: 'New Password',
                    validator: FormValidators.password,
                  ),
                  const SizedBox(height: 16), 
                  
                  AppPasswordField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    validator: (value) => FormValidators.confirmPassword(
                      value, 
                      _passwordController.text
                    ),
                  ),
                  const SizedBox(height: 32), 
                  
                  AppButton(
                    text: 'Reset Password',
                    onPressed: _resetPassword,
                    isLoading: _isLoading,
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