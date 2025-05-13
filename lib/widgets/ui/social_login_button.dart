import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final IconData? iconData;
  final Widget? customIcon;
  final Color? color;
  final VoidCallback? onPressed; 
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
        onPressed: onPressed, 
      ),
    );
  }
}