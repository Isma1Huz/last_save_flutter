import 'package:flutter/material.dart';
import 'package:last_save/screens/reset_password_screen.dart';
import 'package:last_save/utils/app_theme.dart';
import 'package:last_save/widgets/app_button.dart';
import 'package:last_save/widgets/app_layout.dart';
import 'package:last_save/widgets/otp_input_field.dart';

/// OTPVerificationScreen allows users to verify their email with a code
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

        // Simulate network delay
        await Future.delayed(const Duration(seconds: 1));

        setState(() {
        _isLoading = false;
        });

        if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
            (route) => false,
        );
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
        content: Text('Verification code resent'),
      ),
    );
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          const SectionTitle(
            title: 'OTP Verification',
          ),
          const VerticalSpace(height: 8),
          SectionSubtitle(
            text: 'Enter the verification code we just sent on your email address ${widget.email}.',
          ),
          const VerticalSpace(height: 32),
          
          // OTP input fields
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
          
          // Verify button
          AppButton(
            text: 'Verify',
            onPressed: _verifyOTP,
            isLoading: _isLoading,
          ),
          const VerticalSpace(height: 24),
          
          // Resend code link
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
    );
  }
}