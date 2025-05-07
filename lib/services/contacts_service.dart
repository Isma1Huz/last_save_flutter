import 'package:flutter/material.dart';
import 'package:last_save/models/category.dart';
import 'package:last_save/models/contact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service for managing contact categories and saved contacts
class ContactsService {
  static const String _categoriesKey = 'contact_categories';
  static const String _categoryContactsPrefix = 'category_contacts_';
  
  /// Get all categories
  static Future<List<Category>> getCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final categoriesJson = prefs.getStringList(_categoriesKey) ?? [];
      
      final categories = categoriesJson
          .map((json) => Category.fromJson(jsonDecode(json)))
          .toList();
      
      // Load contact count for each category
      for (var i = 0; i < categories.length; i++) {
        final category = categories[i];
        final contactIds = await _getCategoryContactIds(category.id);
        categories[i] = category.copyWith(contactCount: contactIds.length);
      }
      
      return categories;
    } catch (e) {
      debugPrint('Error loading categories: $e');
      return [];
    }
  }
  
  /// Add a new category
  static Future<Category> addCategory({
    required String title,
    String? description,
    required IconData icon,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final categoriesJson = prefs.getStringList(_categoriesKey) ?? [];
      
      // Generate a unique ID
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Find the icon index in the available icons list
      int iconIndex = Category.availableIcons.indexOf(icon);
      if (iconIndex == -1) {
        // If icon not found, use the first one as default
        iconIndex = 0;
      }
      
      // Create new category
      final newCategory = Category(
        id: id,
        title: title,
        description: description,
        iconIndex: iconIndex,
        contactCount: 0,
      );
      
      // Add to list
      categoriesJson.add(jsonEncode(newCategory.toJson()));
      
      // Save updated list
      await prefs.setStringList(_categoriesKey, categoriesJson);
      
      return newCategory;
    } catch (e) {
      debugPrint('Error adding category: $e');
      throw Exception('Failed to add category: $e');
    }
  }
  
  /// Delete a category
  static Future<bool> deleteCategory(String categoryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final categoriesJson = prefs.getStringList(_categoriesKey) ?? [];
      
      // Parse categories
      final categories = categoriesJson
          .map((json) => Category.fromJson(jsonDecode(json)))
          .toList();
      
      // Remove the category
      categories.removeWhere((category) => category.id == categoryId);
      
      // Convert back to JSON
      final updatedCategoriesJson = categories
          .map((category) => jsonEncode(category.toJson()))
          .toList();
      
      // Save updated list
      await prefs.setStringList(_categoriesKey, updatedCategoriesJson);
      
      // Remove contacts associated with this category
      await prefs.remove('$_categoryContactsPrefix$categoryId');
      
      return true;
    } catch (e) {
      debugPrint('Error deleting category: $e');
      return false;
    }
  }
  
  /// Add a contact to a category
  static Future<bool> addContactToCategory(String categoryId, Contact contact) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactIdsJson = prefs.getStringList('$_categoryContactsPrefix$categoryId') ?? [];
      
      // Check if contact is already in the category
      if (contactIdsJson.contains(contact.id)) {
        return true; // Already added
      }
      
      // Add contact ID to the list
      contactIdsJson.add(contact.id);
      
      // Save updated list
      await prefs.setStringList('$_categoryContactsPrefix$categoryId', contactIdsJson);
      
      // Update category contact count
      await _updateCategoryContactCount(categoryId);
      
      return true;
    } catch (e) {
      debugPrint('Error adding contact to category: $e');
      return false;
    }
  }
  
  /// Remove a contact from a category
  static Future<bool> removeContactFromCategory(String categoryId, String contactId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactIdsJson = prefs.getStringList('$_categoryContactsPrefix$categoryId') ?? [];
      
      // Remove contact ID from the list
      contactIdsJson.remove(contactId);
      
      // Save updated list
      await prefs.setStringList('$_categoryContactsPrefix$categoryId', contactIdsJson);
      
      // Update category contact count
      await _updateCategoryContactCount(categoryId);
      
      return true;
    } catch (e) {
      debugPrint('Error removing contact from category: $e');
      return false;
    }
  }
  
  /// Get contacts in a category
  static Future<List<Contact>> getCategoryContacts(String categoryId) async {
    try {
      final contactIds = await _getCategoryContactIds(categoryId);
      
      // TODO: Implement fetching actual contacts by IDs
      // This would typically involve querying your device contacts service
      // For now, return empty list
      return [];
    } catch (e) {
      debugPrint('Error getting category contacts: $e');
      return [];
    }
  }
  
  /// Get contact IDs in a category
  static Future<List<String>> _getCategoryContactIds(String categoryId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('$_categoryContactsPrefix$categoryId') ?? [];
  }
  
  /// Update category contact count
  static Future<void> _updateCategoryContactCount(String categoryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final categoriesJson = prefs.getStringList(_categoriesKey) ?? [];
      
      // Parse categories
      final categories = categoriesJson
          .map((json) => Category.fromJson(jsonDecode(json)))
          .toList();
      
      // Find the category
      final index = categories.indexWhere((category) => category.id == categoryId);
      if (index == -1) return;
      
      // Get contact count
      final contactIds = await _getCategoryContactIds(categoryId);
      
      // Update category
      categories[index] = categories[index].copyWith(contactCount: contactIds.length);
      
      // Convert back to JSON
      final updatedCategoriesJson = categories
          .map((category) => jsonEncode(category.toJson()))
          .toList();
      
      // Save updated list
      await prefs.setStringList(_categoriesKey, updatedCategoriesJson);
    } catch (e) {
      debugPrint('Error updating category contact count: $e');
    }
  }
}
