import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:last_save/models/contact.dart' as app;
import 'package:last_save/services/favorite_service.dart';
import 'package:last_save/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DeviceContactsService {
  static final DeviceContactsService _instance = DeviceContactsService._internal();
  factory DeviceContactsService() => _instance;
  DeviceContactsService._internal();

  List<app.Contact>? _deviceContacts;
  final PermissionService _permissionService = PermissionService();
  
  final StreamController<bool> _contactsChangedController = StreamController<bool>.broadcast();
  Stream<bool> get onContactsChanged => _contactsChangedController.stream;

  bool get isLoaded => _deviceContacts != null;
  
  void notifyContactsChanged() {
    clearCache(); 
    _contactsChangedController.add(true);
  }

DateTime? _extractSavedTimestamp(Contact contact) {
  try {
    final savedEvent = contact.events.firstWhere(
      (event) => event.customLabel?.startsWith('Saved on:') ?? false,
      orElse: () => Event(year: 0, month: 0, day: 0),
    );
    
    if (savedEvent.customLabel?.startsWith('Saved on:') ?? false) {
      final timestampStr = savedEvent.customLabel!.substring('Saved on: '.length);
      try {
        return DateFormat('yyyy-MM-dd HH:mm:ss').parse(timestampStr);
      } catch (e) {
        debugPrint('Error parsing timestamp: $e');
        if (savedEvent.year! > 0 && savedEvent.month > 0 && savedEvent.day > 0) {
          return DateTime(savedEvent.year!, savedEvent.month, savedEvent.day);
        }
      }
    }



    return null;
  } catch (e) {
    debugPrint('Error extracting saved timestamp: $e');
    return null;
  }
}

  
  Future<List<app.Contact>> getDeviceContacts() async {
    if (_deviceContacts != null) {
      return _deviceContacts!;
    }
    
    try {
      await _permissionService.init();
      // ignore: unused_local_variable
      final onboardingCompleted = await _permissionService.isOnboardingCompleted();
      
      final status = await ph.Permission.contacts.status;
      debugPrint('Permission status from permission_handler: ${status.toString()}');
      
      if (!status.isGranted) {
        if (status.isPermanentlyDenied) {
          throw Exception('Contacts permission permanently denied. Please enable in settings.');
        }
        
        final result = await ph.Permission.contacts.request();
        debugPrint('Permission request result: ${result.toString()}');
        
        if (!result.isGranted) {
          throw Exception('Contacts permission not granted');
        }
      }
      
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

      
      _deviceContacts = await Future.wait(deviceContacts.map((contact) async {
        Contact? fullContact;
        try {
          fullContact = await FlutterContacts.getContact(contact.id);
          debugPrint('Got full contact for ${contact.displayName}');
        } catch (e) {
          debugPrint('Error getting full contact: $e');
        }
        
        final contactToUse = fullContact ?? contact;
        
        String phoneNumber = '';
        if (contactToUse.phones.isNotEmpty) {
          phoneNumber = contactToUse.phones.first.number;
        }
        
        String? email;
        if (contactToUse.emails.isNotEmpty) {
          email = contactToUse.emails.first.address;
        }
        
        Uint8List? photo = contactToUse.photo;
        if (photo == null && contactToUse.thumbnail != null) {
          photo = contactToUse.thumbnail;
        }
        
        final savedTimestamp = _extractSavedTimestamp(contactToUse);

        final isFavorite = FavoritesService().isFavorite(contactToUse.id);

        return app.Contact(
          id: contactToUse.id,
          name: contactToUse.displayName,
          phoneNumber: phoneNumber,
          email: email,
          categories: [], 
          photo: photo,
          savedTimestamp: savedTimestamp, 
          isFavorite: await isFavorite,
        );
      }).toList());
      
      debugPrint('Converted ${_deviceContacts!.length} contacts to app model');
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('contacts_permission_granted', true);
      
      return _deviceContacts!;
    } catch (e) {
      debugPrint('Error loading device contacts: $e');
      throw Exception('Failed to load contacts: $e');
    }
  }
  
  void clearCache() {
    _deviceContacts = null;
  }
  
  void dispose() {
    _contactsChangedController.close();
  }
}