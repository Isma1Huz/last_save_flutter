import 'package:flutter/material.dart';
import 'package:last_save/utils/app_theme.dart';
import 'package:last_save/widgets/onboarding/page_indicator.dart';

class OnboardingContent extends StatelessWidget {
  final Map<String, dynamic> data;
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;

  const OnboardingContent({
    super.key,
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = data['image'] as String;
    final pageIndex = int.tryParse(imagePath.split('on').last.split('.').first) ?? 0;
    pageIndex - 1;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Image.asset(
              data['image'],
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            data['title'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data['description'],
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          PageIndicator(
            currentPage: currentPage,
            totalPages: totalPages,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
