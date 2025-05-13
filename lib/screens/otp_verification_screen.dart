import 'package:flutter/material.dart';
import 'package:last_save/screens/reset_password_screen.dart';
import 'package:last_save/utils/app_theme.dart';
import 'package:last_save/widgets/ui/app_button.dart';
import 'package:last_save/widgets/layout/app_layout.dart';
import 'package:last_save/widgets/ui/otp_input_field.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  bool _isLoading = false;
  String _otp = '';

  void _verifyOTP() async {
    if (_otp.length == 4) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                email: widget.email,
                resetCode: _otp,
              ),
            ),
            (route) => false,
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
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 4-digit code')),
      );
    }
  }

  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppTheme.successColor,
        content: Text('Verification code resent'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'OTP Verification',
          ),
          const VerticalSpace(height: 8),
          SectionSubtitle(
            text: 'Enter the verification code we just sent on your email address ${widget.email}.',
          ),
          const VerticalSpace(height: 32),
          
          Center(
            child: OTPInputField(
              length: 4,
              onCompleted: (value) {
                setState(() {
                  _otp = value;
                });
              },
            ),
          ),
          const VerticalSpace(height: 32),
          
          AppButton(
            text: 'Verify',
            onPressed: _verifyOTP,
            isLoading: _isLoading,
          ),
          const VerticalSpace(height: 24),
          
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't receive code?"),
                AppTextButton(
                  text: 'Resend',
                  onPressed: _resendCode,
                ),
              ],
            ),
          ),
        ],
      ),
      )

    );
  }
}