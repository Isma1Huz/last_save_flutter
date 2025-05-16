// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:last_save/models/category.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/services/device_contacts_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class CategoriesService {
  static const String _categoriesKey = 'contact_categories';
  static const String _categoryContactsPrefix = 'category_contacts_';
  
  static final StreamController<String> _categoryChangedController = StreamController<String>.broadcast();
  static Stream<String> get onCategoryChanged => _categoryChangedController.stream;
  
  static final StreamController<Map<String, dynamic>> _contactCategoryChangedController = 
      StreamController<Map<String, dynamic>>.broadcast();
  static Stream<Map<String, dynamic>> get onContactCategoryChanged => _contactCategoryChangedController.stream;
  
  static void _notifyCategoryChanged(String categoryId) {
    _categoryChangedController.add(categoryId);
    DeviceContactsService().notifyContactsChanged();
  }

  static void _notifyContactCategoryChanged(String categoryId, String contactId, String action) {
    _contactCategoryChangedController.add({
      'categoryId': categoryId,
      'contactId': contactId,
      'action': action, 
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
    
    _notifyCategoryChanged(categoryId);
  }

  /// Get all categories
  static Future<List<Category>> getCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final categoriesJson = prefs.getStringList(_categoriesKey) ?? [];
      
      final categories = categoriesJson
          .map((json) => Category.fromJson(jsonDecode(json)))
          .toList();
      
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
      
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      
      int iconIndex = Category.availableIcons.indexOf(icon);
      if (iconIndex == -1) {
        iconIndex = 0;
      }
      
      final newCategory = Category(
        id: id,
        title: title,
        description: description,
        iconIndex: iconIndex,
        contactCount: 0,
      );
      
      categoriesJson.add(jsonEncode(newCategory.toJson()));
      
      await prefs.setStringList(_categoriesKey, categoriesJson);
      
      _notifyCategoryChanged("all");
      
      return newCategory;
    } catch (e) {
      debugPrint('Error adding category: $e');
      throw Exception('Failed to add category: $e');
    }
  }
  
  /// Update an existing category
  static Future<bool> updateCategory(Category updatedCategory) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final categoriesJson = prefs.getStringList(_categoriesKey) ?? [];
      
      final categories = categoriesJson
          .map((json) => Category.fromJson(jsonDecode(json)))
          .toList();
      
      final index = categories.indexWhere((category) => category.id == updatedCategory.id);
      if (index == -1) {
        throw Exception('Category not found');
      }
      
      final contactCount = categories[index].contactCount;
      categories[index] = updatedCategory.copyWith(contactCount: contactCount);
      
      final updatedCategoriesJson = categories
          .map((category) => jsonEncode(category.toJson()))
          .toList();
      
      await prefs.setStringList(_categoriesKey, updatedCategoriesJson);
      
      _notifyCategoryChanged(updatedCategory.id);
      
      return true;
    } catch (e) {
      debugPrint('Error updating category: $e');
      throw Exception('Failed to update category: $e');
    }
  }
  
  /// Delete a category
  static Future<bool> deleteCategory(String categoryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final categoriesJson = prefs.getStringList(_categoriesKey) ?? [];
      
      final categories = categoriesJson
          .map((json) => Category.fromJson(jsonDecode(json)))
          .toList();
      
      categories.removeWhere((category) => category.id == categoryId);
      
      final updatedCategoriesJson = categories
          .map((category) => jsonEncode(category.toJson()))
          .toList();
      
      await prefs.setStringList(_categoriesKey, updatedCategoriesJson);
      
      await prefs.remove('$_categoryContactsPrefix$categoryId');
      
      _notifyCategoryChanged("all");
      
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
      
      if (contactIdsJson.contains(contact.id)) {
        return true; 
      }
      
      contactIdsJson.add(contact.id);
      
      await prefs.setStringList('$_categoryContactsPrefix$categoryId', contactIdsJson);
      
      await _updateCategoryContactCount(categoryId);
      
      _notifyContactCategoryChanged(categoryId, contact.id, 'add');
      
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
      
      contactIdsJson.remove(contactId);
      
      await prefs.setStringList('$_categoryContactsPrefix$categoryId', contactIdsJson);
      
      await _updateCategoryContactCount(categoryId);
      
      _notifyContactCategoryChanged(categoryId, contactId, 'remove');
      
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
      if (contactIds.isEmpty) {
        return [];
      }
      
      final deviceContactsService = DeviceContactsService();
      final allContacts = await deviceContactsService.getDeviceContacts();
      
      final categoryContacts = allContacts
          .where((contact) => contactIds.contains(contact.id))
          .toList();
      
      return categoryContacts;
    } catch (e) {
      debugPrint('Error getting category contacts: $e');
      return [];
    }
  }
  
  /// Check if a contact is in a category
  static Future<bool> isContactInCategory(String categoryId, String contactId) async {
    try {
      final contactIds = await _getCategoryContactIds(categoryId);
      return contactIds.contains(contactId);
    } catch (e) {
      debugPrint('Error checking if contact is in category: $e');
      return false;
    }
  }
  
  /// Get contact IDs in a category
  static Future<List<String>> _getCategoryContactIds(String categoryId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('$_categoryContactsPrefix$categoryId') ?? [];
  }
  
  /// Get all categories a contact belongs to
  static Future<List<Category>> getCategoriesForContact(String contactId) async {
    try {
      final allCategories = await getCategories();
      final result = <Category>[];
      
      for (final category in allCategories) {
        final contactIds = await _getCategoryContactIds(category.id);
        if (contactIds.contains(contactId)) {
          result.add(category);
        }
      }
      
      return result;
    } catch (e) {
      debugPrint('Error getting categories for contact: $e');
      return [];
    }
  }
  
  static Future<void> _updateCategoryContactCount(String categoryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final categoriesJson = prefs.getStringList(_categoriesKey) ?? [];
      
      final categories = categoriesJson
          .map((json) => Category.fromJson(jsonDecode(json)))
          .toList();
      
      final index = categories.indexWhere((category) => category.id == categoryId);
      if (index == -1) return;
      
      final contactIds = await _getCategoryContactIds(categoryId);
      
      categories[index] = categories[index].copyWith(contactCount: contactIds.length);
      
      final updatedCategoriesJson = categories
          .map((category) => jsonEncode(category.toJson()))
          .toList();
      
      await prefs.setStringList(_categoriesKey, updatedCategoriesJson);
    } catch (e) {
      debugPrint('Error updating category contact count: $e');
    }
  }
  
  static void dispose() {
    _categoryChangedController.close();
    _contactCategoryChangedController.close();
  }
}
