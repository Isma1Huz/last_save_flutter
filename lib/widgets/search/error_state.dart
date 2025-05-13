import 'package:flutter/material.dart';
import 'package:last_save/utils/app_theme.dart';

class ErrorState extends StatelessWidget {
  final String errorMessage;
  final bool isPermanentlyDenied;
  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;

  const ErrorState({
    super.key,
    required this.errorMessage,
    required this.isPermanentlyDenied,
    required this.onRetry,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          if (isPermanentlyDenied)
            ElevatedButton(
              onPressed: onOpenSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Open Settings',
                style: TextStyle(color: Colors.white),
              ),
            )
          else
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
