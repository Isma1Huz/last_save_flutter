import 'package:flutter/material.dart';
import 'package:last_save/utils/app_theme.dart';

/// A primary button with consistent styling
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Changed to nullable
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(text),
      ),
    );
  }
}

/// A secondary (outlined) button with consistent styling
class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Changed to nullable
  final bool isFullWidth;

  const AppOutlinedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

/// A text button with primary color
class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Changed to nullable

  const AppTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}