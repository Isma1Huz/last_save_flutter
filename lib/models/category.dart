import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;
  final String? description;
  final int iconIndex; // Store icon index instead of IconData
  final int contactCount;

  // Predefined list of available icons
  static const List<IconData> availableIcons = [
    Icons.folder,
    Icons.work,
    Icons.person,
    Icons.favorite,
    Icons.star,
    Icons.school,
    Icons.home,
    Icons.sports,
    Icons.music_note,
    Icons.local_dining,
    Icons.local_hospital,
    Icons.shopping_cart,
    Icons.directions_car,
    Icons.flight,
    Icons.hotel,
    Icons.beach_access,
  ];

  Category({
    required this.id,
    required this.title,
    this.description,
    required this.iconIndex,
    this.contactCount = 0,
  });

  // Get the actual IconData from the index
  IconData get icon => iconIndex < availableIcons.length 
      ? availableIcons[iconIndex] 
      : Icons.folder; // Default icon

  Category copyWith({
    String? id,
    String? title,
    String? description,
    int? iconIndex,
    int? contactCount,
  }) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconIndex: iconIndex ?? this.iconIndex,
      contactCount: contactCount ?? this.contactCount,
    );
  }

  // Store only the icon index
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconIndex': iconIndex,
      'contactCount': contactCount,
    };
  }

  // Load from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconIndex: json['iconIndex'] ?? 0,
      contactCount: json['contactCount'] ?? 0,
    );
  }
}
