import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:last_save/models/contact.dart' as app;
import 'package:last_save/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:shared_preferences/shared_preferences.dart';

class DeviceContactsService {
  // Singleton pattern
  static final DeviceContactsService _instance = DeviceContactsService._internal();
  factory DeviceContactsService() => _instance;
  DeviceContactsService._internal();

  // Cache for device contacts
  List<app.Contact>? _deviceContacts;
  final PermissionService _permissionService = PermissionService();
  
  // Check if contacts are loaded
  bool get isLoaded => _deviceContacts != null;
  
  // Get device contacts
  Future<List<app.Contact>> getDeviceContacts() async {
    // Return cached contacts if available
    if (_deviceContacts != null) {
      return _deviceContacts!;
    }
    
    try {
      // First check if onboarding was completed
      await _permissionService.init();
      final onboardingCompleted = await _permissionService.isOnboardingCompleted();
      
      if (!onboardingCompleted) {
        throw Exception('Onboarding not completed');
      }
      
      // Check permission status using permission_handler directly
      // instead of using the method that requires context
      final status = await ph.Permission.contacts.status;
      debugPrint('Permission status from permission_handler: ${status.toString()}');
      
      if (!status.isGranted) {
        // If permission was denied permanently, throw exception
        if (status.isPermanentlyDenied) {
          throw Exception('Contacts permission permanently denied. Please enable in settings.');
        }
        
        // Try to request permission using permission_handler directly
        final result = await ph.Permission.contacts.request();
        debugPrint('Permission request result: ${result.toString()}');
        
        if (!result.isGranted) {
          throw Exception('Contacts permission not granted');
        }
      }
      
      // Request permission using flutter_contacts
      // This method both checks and requests permission
      final requestResult = await FlutterContacts.requestPermission();
      debugPrint('Flutter_contacts permission request result: $requestResult');
      
      if (!requestResult) {
        throw Exception('Contacts permission not granted by flutter_contacts');
      }
      
      // Fetch contacts from device with photo and all properties
      debugPrint('Fetching contacts...');
      final deviceContacts = await FlutterContacts.getContacts(
        withPhoto: true,
        withProperties: true,
        withThumbnail: true,
      );
      
      debugPrint('Found ${deviceContacts.length} contacts on device');
      
      if (deviceContacts.isEmpty) {
        debugPrint('No contacts found on device');
        return [];
      }
      
      // Convert to app Contact model
      _deviceContacts = await Future.wait(deviceContacts.map((contact) async {
        // Get full contact with all details
        Contact? fullContact;
        try {
          fullContact = await FlutterContacts.getContact(contact.id);
          debugPrint('Got full contact for ${contact.displayName}');
        } catch (e) {
          debugPrint('Error getting full contact: $e');
        }
        
        // Use the contact we have, either full or partial
        final contactToUse = fullContact ?? contact;
        
        // Get primary phone number
        String phoneNumber = '';
        if (contactToUse.phones.isNotEmpty) {
          phoneNumber = contactToUse.phones.first.number;
        }
        
        // Get primary email
        String? email;
        if (contactToUse.emails.isNotEmpty) {
          email = contactToUse.emails.first.address;
        }
        
        // Get photo
        Uint8List? photo = contactToUse.photo;
        if (photo == null && contactToUse.thumbnail != null) {
          photo = contactToUse.thumbnail;
        }
        
        return app.Contact(
          id: contactToUse.id,
          name: contactToUse.displayName,
          phoneNumber: phoneNumber,
          email: email,
          categories: [], // New contacts don't belong to any category initially
          photo: photo,
        );
      }).toList());
      
      debugPrint('Converted ${_deviceContacts!.length} contacts to app model');
      
      // Save permission status to shared preferences to avoid future issues
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('contacts_permission_granted', true);
      
      return _deviceContacts!;
    } catch (e) {
      debugPrint('Error loading device contacts: $e');
      throw Exception('Failed to load contacts: $e');
    }
  }
  
  // Clear cache to force reload
  void clearCache() {
    _deviceContacts = null;
  }
}