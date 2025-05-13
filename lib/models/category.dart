import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;
  final String? description;
  final int iconIndex;
  final int contactCount;

  Category({
    required this.id,
    required this.title,
    this.description,
    required this.iconIndex,
    this.contactCount = 0,
  });

  // Available icons for categories
  static List<IconData> availableIcons = [
    Icons.person,
    Icons.work,
    Icons.family_restroom,
    Icons.favorite,
    Icons.school,
    Icons.sports,
    Icons.local_hospital,
    Icons.restaurant,
    Icons.shopping_cart,
    Icons.star,
    Icons.public,
    Icons.phone,
  ];

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconIndex': iconIndex,
      'contactCount': contactCount,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconIndex: json['iconIndex'],
      contactCount: json['contactCount'] ?? 0,
    );
  }
}
