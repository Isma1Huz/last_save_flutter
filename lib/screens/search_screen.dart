import 'package:flutter/material.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/services/device_contacts_service.dart';
import 'package:last_save/services/permission_service.dart';
import 'package:last_save/utils/app_theme.dart';
import 'package:permission_handler/permission_handler.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final DeviceContactsService _deviceContactsService = DeviceContactsService();
  final PermissionService _permissionService = PermissionService();
  // final prefs = await SharedPreferences.getInstance();
  // print("Contacts granted: ${prefs.getBool('Permission.contacts')}");
  // print("Location granted: ${prefs.getBool('Permission.location')}");
  // print("Storage granted: ${prefs.getBool('Permission.storage')}");

  
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isPermanentlyDenied = false;
  
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
      // Check permission status first
      await _permissionService.init();
      final permissionStatus = await _permissionService.checkContactsPermission();
      
      if (!permissionStatus['isGranted']) {
        // If permission is permanently denied, show special message
        if (permissionStatus['isPermanentlyDenied']) {
          setState(() {
            _isLoading = false;
            _hasError = true;
            _isPermanentlyDenied = true;
            _errorMessage = 'Contacts permission permanently denied. Please enable in settings.';
          });
          return;
        }
        
        // Try to request permission
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
      
      // Load device contacts
      final contacts = await _deviceContactsService.getDeviceContacts();
      
      setState(() {
        _contacts = contacts;
        _filteredContacts = contacts;
        _isLoading = false;
      });
      
      // Show success message if contacts were loaded
      if (contacts.isNotEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Loaded ${contacts.length} contacts'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load contacts: ${e.toString()}';
        
        // Check if error is about permanently denied permission
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
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        return contact.name.toLowerCase().contains(lowercaseQuery) ||
               contact.phoneNumber.contains(query) ||
               (contact.email?.toLowerCase().contains(lowercaseQuery) ?? false);
      }).toList();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Clear cache and reload contacts
              _deviceContactsService.clearCache();
              _loadContacts();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterContacts('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _filterContacts,
            ),
          ),
          Expanded(
            child: _buildContactsList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactsList() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading contacts...'),
          ],
        ),
      );
    }
    
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            if (_isPermanentlyDenied)
              ElevatedButton(
                onPressed: () async {
                  await openAppSettings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Open Settings',
                  style: TextStyle(color: Colors.white),
                ),
              )
            else
              ElevatedButton(
                onPressed: _loadContacts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(color: Colors.white),
                ),
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
            const Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No contacts found matching "${_searchController.text}"'
                  : 'No contacts found on this device',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: _filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = _filteredContacts[index];
        return ListTile(
          leading: _buildContactAvatar(contact),
          title: Text(contact.name),
          subtitle: Text(contact.phoneNumber),
          trailing: contact.email != null ? const Icon(Icons.email) : null,
          onTap: () {
            // Handle contact selection
            _showContactDetails(contact);
          },
        );
      },
    );
  }
  
  // Rest of the code remains the same...
  Widget _buildContactAvatar(Contact contact) {
    if (contact.photo != null) {
      return CircleAvatar(
        backgroundImage: MemoryImage(contact.photo!),
      );
    }
    
    return CircleAvatar(
      backgroundColor: AppTheme.primaryColor,
      child: Text(
        contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
  
  void _showContactDetails(Contact contact) {
    // Existing implementation...
  }
}