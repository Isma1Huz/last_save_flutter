import 'package:flutter/material.dart';

class ImagePrecacher {
  static Future<void> precacheAssets(
    BuildContext context, 
    List<String> assetPaths
  ) async {
    for (final path in assetPaths) {
      await precacheImage(AssetImage(path), context);
    }
  }
  
  static Future<void> precacheOnboardingImages(BuildContext context) async {
    await precacheAssets(context, [
      'assets/images/on1.jpg',
      'assets/images/on2.jpg',
      'assets/images/on3.jpg',
      'assets/images/logo.png',
    ]);
  }
}
