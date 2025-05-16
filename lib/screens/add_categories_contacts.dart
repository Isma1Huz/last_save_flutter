// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:last_save/models/category.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/services/categories_service.dart';
import 'package:last_save/services/device_contacts_service.dart';
import 'package:last_save/services/permission_service.dart';
import 'package:last_save/widgets/categories/search_input.dart';
import 'package:last_save/widgets/categories/selectable_contact_list.dart';
import 'package:permission_handler/permission_handler.dart';

class AddContactsToCategoryScreen extends StatefulWidget {
  final Category category;

  const AddContactsToCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<AddContactsToCategoryScreen> createState() => _AddContactsToCategoryScreenState();
}

class _AddContactsToCategoryScreenState extends State<AddContactsToCategoryScreen> {
  final DeviceContactsService _deviceContactsService = DeviceContactsService();
  final PermissionService _permissionService = PermissionService();
  
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  final Set<String> _selectedContactIds = {};
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isPermanentlyDenied = false;
  bool _isSaving = false;
  
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadContacts();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _loadContacts() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
      _isPermanentlyDenied = false;
    });
    
    try {
      await _permissionService.init();
      final permissionStatus = await _permissionService.checkContactsPermission();
      
      if (!permissionStatus['isGranted']) {
        if (permissionStatus['isPermanentlyDenied']) {
          setState(() {
            _isLoading = false;
            _hasError = true;
            _isPermanentlyDenied = true;
            _errorMessage = 'Contacts permission permanently denied. Please enable in settings.';
          });
          return;
        }
        
        final hasPermission = await _permissionService.requestContactsPermission(
          context: context,
          showRationale: true,
        );
        
        if (!hasPermission) {
          setState(() {
            _isLoading = false;
            _hasError = true;
            _errorMessage = 'Contacts permission denied. Please grant permission to view contacts.';
          });
          return;
        }
      }
      
      final contacts = await _deviceContactsService.getDeviceContacts();
      
      final categoryContacts = await CategoriesService.getCategoryContacts(widget.category.id);
      final categoryContactIds = categoryContacts.map((c) => c.id).toSet();
      
      _selectedContactIds.addAll(categoryContactIds);
      
      setState(() {
        _contacts = contacts;
        _filteredContacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load contacts: ${e.toString()}';
        
        if (e.toString().contains('permanently denied')) {
          _isPermanentlyDenied = true;
        }
      });
    }
  }
  
  void _filterContacts(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredContacts = _contacts;
      });
      return;
    }
    
    final lowercaseQuery = query.toLowerCase();
    final filtered = _contacts.where((contact) {
      return contact.name.toLowerCase().contains(lowercaseQuery) ||
             contact.phoneNumber.contains(query) ||
             (contact.email?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
    
    setState(() {
      _filteredContacts = filtered;
    });
  }
  
  void _toggleContactSelection(Contact contact) {
    setState(() {
      if (_selectedContactIds.contains(contact.id)) {
        _selectedContactIds.remove(contact.id);
      } else {
        _selectedContactIds.add(contact.id);
      }
    });
  }
  
  Future<void> _saveSelectedContacts() async {
    setState(() {
      _isSaving = true;
    });
    
    try {
      final categoryContacts = await CategoriesService.getCategoryContacts(widget.category.id);
      final existingContactIds = categoryContacts.map((c) => c.id).toSet();
      
      final contactsToAdd = _selectedContactIds.difference(existingContactIds);
      
      final contactsToRemove = existingContactIds.difference(_selectedContactIds);
      
      for (final contactId in contactsToAdd) {
        final contact = _contacts.firstWhere((c) => c.id == contactId);
        await CategoriesService.addContactToCategory(widget.category.id, contact);
      }
      
      for (final contactId in contactsToRemove) {
        await CategoriesService.removeContactFromCategory(widget.category.id, contactId);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Updated contacts in ${widget.category.title}'))
      );
      
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating contacts: ${e.toString()}'))
      );
      setState(() {
        _isSaving = false;
      });
    }
  }
  
  Widget _buildContentArea() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (_isPermanentlyDenied)
              ElevatedButton(
                onPressed: () async {
                  await openAppSettings();
                },
                child: const Text('Open Settings'),
              )
            else
              ElevatedButton(
                onPressed: _loadContacts,
                child: const Text('Retry'),
              ),
          ],
        ),
      );
    }
    
    if (_filteredContacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No contacts found for "${_searchController.text}"'
                  : 'No contacts found',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }
    
    return SelectableContactsList(
      contacts: _filteredContacts,
      selectedContactIds: _selectedContactIds,
      onContactTap: _toggleContactSelection,
      categoryId: widget.category.id,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage ${widget.category.title}'),
      ),
      body: Column(
        children: [
          SearchInput(
            controller: _searchController,
            onChanged: _filterContacts,
            onClear: () {
              _searchController.clear();
              _filterContacts('');
            },
          ),
          Expanded(
            child: _buildContentArea(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isSaving ? null : _saveSelectedContacts,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isSaving
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('Saving...'),
                  ],
                )
              : Text('Save changes (${_selectedContactIds.length} contacts)'),
        ),
      ),
    );
  }
}
