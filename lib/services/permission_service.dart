// ignore_for_file: unused_field, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionService {
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _contactsPermissionKey = 'contacts_permission_granted';
  static const String _locationPermissionKey = 'location_permission_granted';
  static const String _storagePermissionKey = 'storage_permission_granted';
  
  late SharedPreferences _prefs;
  
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }
  
  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
    
    await _savePermissionStatuses();
  }
  
  Future<void> _savePermissionStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    
    final contactsStatus = await Permission.contacts.status;
    await prefs.setBool(_contactsPermissionKey, contactsStatus.isGranted);
    
    final locationStatus = await Permission.location.status;
    await prefs.setBool(_locationPermissionKey, locationStatus.isGranted);
    
    final storageStatus = await Permission.storage.status;
    await prefs.setBool(_storagePermissionKey, storageStatus.isGranted);
    
    debugPrint('Saved permission statuses - Contacts: ${contactsStatus.isGranted}, '
        'Location: ${locationStatus.isGranted}, Storage: ${storageStatus.isGranted}');
  }
  
  Future<Map<String, dynamic>> checkContactsPermission() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedResult = prefs.getBool(_contactsPermissionKey);
    
    if (cachedResult == true) {
      final currentStatus = await Permission.contacts.status;
      
      if (!currentStatus.isGranted) {
        await prefs.setBool(_contactsPermissionKey, false);
      } else {
        debugPrint('Using cached contacts permission: granted');
        return {
          'isGranted': true,
          'isPermanentlyDenied': false,
        };
      }
    }
    
    final status = await Permission.contacts.status;
    debugPrint('Contacts permission status: $status');
    
    await prefs.setBool(_contactsPermissionKey, status.isGranted);
    
    return {
      'isGranted': status.isGranted,
      'isPermanentlyDenied': status.isPermanentlyDenied,
    };
  }
  
  Future<bool> hasContactsPermission() async {
    final result = await checkContactsPermission();
    return result['isGranted'];
  }
  
  Future<bool> requestContactsPermission({
    required BuildContext? context,
    bool showRationale = false,
  }) async {
    final status = await Permission.contacts.status;
    debugPrint('Requesting contacts permission. Current status: $status');
    
    if (status.isGranted) {
      debugPrint('Contacts permission already granted');
      await _savePermissionStatus(_contactsPermissionKey, true);
      return true;
    }
    
    if (status.isPermanentlyDenied) {
      debugPrint('Contacts permission permanently denied');
      if (showRationale && context != null) {
        final shouldOpenSettings = await _showPermissionRationaleDialog(
          context: context,
          title: 'Contacts Permission Required',
          message: 'To access your contacts, please enable contacts permission in app settings.',
        );
        
        if (shouldOpenSettings) {
          debugPrint('Opening app settings for contacts permission');
          return openAppSettings();
        }
      }
      return false;
    }
    
    debugPrint('Requesting contacts permission...');
    final result = await Permission.contacts.request();
    debugPrint('Contacts permission request result: $result');
    
    await _savePermissionStatus(_contactsPermissionKey, result.isGranted);
    
    return result.isGranted;
  }
  
  Future<void> _savePermissionStatus(String key, bool isGranted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, isGranted);
    debugPrint('Saved permission status for $key: $isGranted');
  }
  
  Future<bool> hasLocationPermission() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedResult = prefs.getBool(_locationPermissionKey);
    
    if (cachedResult == true) {
      final currentStatus = await Permission.location.status;
      if (!currentStatus.isGranted) {
        await prefs.setBool(_locationPermissionKey, false);
        return false;
      }
      return true;
    }
    
    final status = await Permission.location.status;
    await prefs.setBool(_locationPermissionKey, status.isGranted);
    return status.isGranted;
  }
  
  Future<bool> requestLocationPermission({
    required BuildContext? context,
    bool showRationale = false,
  }) async {
    final status = await Permission.location.status;
    debugPrint('Requesting location permission. Current status: $status');
    
    if (status.isGranted) {
      debugPrint('Location permission already granted');
      await _savePermissionStatus(_locationPermissionKey, true);
      return true;
    }
    
    if (status.isPermanentlyDenied) {
      debugPrint('Location permission permanently denied');
      if (showRationale && context != null) {
        final shouldOpenSettings = await _showPermissionRationaleDialog(
          context: context,
          title: 'Location Permission Required',
          message: 'To use location features, please enable location permission in app settings.',
        );
        
        if (shouldOpenSettings) {
          debugPrint('Opening app settings for location permission');
          return openAppSettings();
        }
      }
      return false;
    }
    
    debugPrint('Requesting location permission...');
    final result = await Permission.location.request();
    debugPrint('Location permission request result: $result');
    
    await _savePermissionStatus(_locationPermissionKey, result.isGranted);
    return result.isGranted;
  }
  
  Future<bool> hasStoragePermission() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedResult = prefs.getBool(_storagePermissionKey);
    
    if (cachedResult == true) {
      final currentStatus = await Permission.storage.status;
      if (!currentStatus.isGranted) {
        await prefs.setBool(_storagePermissionKey, false);
        return false;
      }
      return true;
    }
    
    final status = await Permission.storage.status;
    await prefs.setBool(_storagePermissionKey, status.isGranted);
    return status.isGranted;
  }
  
  Future<bool> requestStoragePermission({
    required BuildContext? context,
    bool showRationale = false,
  }) async {
    final status = await Permission.storage.status;
    debugPrint('Requesting storage permission. Current status: $status');
    
    if (status.isGranted) {
      debugPrint('Storage permission already granted');
      await _savePermissionStatus(_storagePermissionKey, true);
      return true;
    }
    
    if (status.isPermanentlyDenied) {
      debugPrint('Storage permission permanently denied');
      if (showRationale && context != null) {
        final shouldOpenSettings = await _showPermissionRationaleDialog(
          context: context,
          title: 'Storage Permission Required',
          message: 'To save data, please enable storage permission in app settings.',
        );
        
        if (shouldOpenSettings) {
          debugPrint('Opening app settings for storage permission');
          return openAppSettings();
        }
      }
      return false;
    }
    
    debugPrint('Requesting storage permission...');
    final result = await Permission.storage.request();
    debugPrint('Storage permission request result: $result');
    
    await _savePermissionStatus(_storagePermissionKey, result.isGranted);
    return result.isGranted;
  }
  
  Future<bool> _showPermissionRationaleDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  requestPermissions() {}
}