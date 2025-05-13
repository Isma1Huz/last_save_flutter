import 'package:flutter/material.dart';

/// Constants for the onboarding screens
class OnboardingConstants {
  /// Data for onboarding content pages
  static const List<Map<String, dynamic>> onboardingData = [
    {
      'title': 'Find Contacts in Seconds with Smart AI Search',
      'description': 'Effortlessly locate any contact with powerful AI-driven search that understands names, job roles, locations, and even context—helping you stay organized and productive.',
      'image': 'assets/images/on1.jpg',
    },
    {
      'title': 'Visualize Your Network with Contact Relationships',
      'description': 'Explore connections between your contacts through intelligent relationship mapping—whether it\'s colleagues, family, or frequent collaborators, everything is linked.',
      'image': 'assets/images/on2.jpg',
    },
    {
      'title': 'Add Contacts via QR, Save Events & Pin Locations',
      'description': 'Easily add new contacts by scanning QR codes, save important events to profiles, and view contact locations on the map—your contact book just got smarter.',
      'image': 'assets/images/on3.jpg',
    },
  ];

  /// Data for permission requests
  static const List<Map<String, dynamic>> permissionsData = [
    {
      'title': 'Contacts',
      'description': 'Allow LastSave to access your contacts',
      'icon': Icons.contacts,
      'granted': false,
    },
    {
      'title': 'Location',
      'description': 'Allow LastSave to access your location',
      'icon': Icons.location_on,
      'granted': false,
    },
    {
      'title': 'Storage',
      'description': 'Allow LastSave to access your storage',
      'icon': Icons.storage,
      'granted': false,
    },
  ];

  /// List of all image assets used in onboarding
  static const List<String> onboardingImages = [
    'assets/images/on1.jpg',
    'assets/images/on2.jpg',
    'assets/images/on3.jpg',
    'assets/images/logo.png',
  ];
}
