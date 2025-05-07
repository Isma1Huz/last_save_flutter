// lib/widgets/social_login_button.dart
import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final IconData? iconData;
  final Widget? customIcon;
  final Color? color;
  final VoidCallback? onPressed; // Change to nullable

  const SocialLoginButton({
    Key? key,
    this.iconData,
    this.customIcon,
    this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: IconButton(
        icon: customIcon ?? Icon(iconData, color: color),
        onPressed: onPressed, // IconButton already accepts nullable callbacks
      ),
    );
  }
}