// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/screens/contact_view_screen.dart';
import 'package:last_save/services/device_contacts_service.dart';
import 'package:last_save/services/permission_service.dart';
import 'package:last_save/widgets/home/bottom_navigation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:last_save/widgets/search/search_input.dart';
import 'package:last_save/widgets/search/filter_tabs.dart';
import 'package:last_save/widgets/search/contacts_list.dart';
import 'package:last_save/widgets/search/loading_state.dart';
import 'package:last_save/widgets/search/error_state.dart';
import 'package:last_save/widgets/search/empty_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final DeviceContactsService _deviceContactsService = DeviceContactsService();
  final PermissionService _permissionService = PermissionService();
  
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isPermanentlyDenied = false;
  int _currentTab = 0;
  String? _selectedCategoryId;
  
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
        _filteredContacts = _filterContactsByTab(_contacts);
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
      _filteredContacts = _filterContactsByTab(filtered);
    });
  }

  void _onCategorySelected(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _filteredContacts = _filterContactsByTab(_contacts);
    });
  }
  
  List<Contact> _filterContactsByTab(List<Contact> contacts) {
    if (_currentTab == 0) {
      return contacts;
    } else if (_selectedCategoryId != null) {
      return contacts; 
    }
    return contacts;
  }
  
  void _onTabChanged(int tabIndex) {
    setState(() {
      _currentTab = tabIndex;
      // Reset selected category if "All" is selected
      if (tabIndex == 0) {
        _selectedCategoryId = null;
      }
      _filteredContacts = _filterContactsByTab(_contacts);
    });
  }
    
  void _showContactDetails(Contact contact) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ContactViewScreen(contact: contact),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light ? Colors.white : theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SearchInput(
              controller: _searchController,
              onChanged: _filterContacts,
              onClear: () {
                _searchController.clear();
                _filterContacts('');
              },
            ),
            FilterTabs(
              initialTab: _currentTab,
              onTabChanged: _onTabChanged,
              onCategorySelected: _onCategorySelected,
            ),
            Expanded(
              child: _buildContentArea(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),

    );
  }
  
  Widget _buildContentArea() {
    if (_isLoading) {
      return const LoadingState();
    }
    
    if (_hasError) {
      return ErrorState(
        errorMessage: _errorMessage,
        isPermanentlyDenied: _isPermanentlyDenied,
        onRetry: _loadContacts,
        onOpenSettings: () async {
          await openAppSettings();
        },
      );
    }
    
    if (_filteredContacts.isEmpty) {
      return EmptyState(
        hasSearchQuery: _searchController.text.isNotEmpty,
        searchQuery: _searchController.text,
      );
    }
    
    return ContactsList(
      contacts: _filteredContacts,
      onContactTap: _showContactDetails,
    );
  }
}





