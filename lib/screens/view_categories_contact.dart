import 'package:flutter/material.dart';
import 'package:last_save/models/category.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/screens/add_categories_contacts.dart';
import 'package:last_save/screens/contact_view_screen.dart';
import 'package:last_save/services/categories_service.dart';
import 'package:last_save/widgets/search/contacts_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryContactsScreen extends StatefulWidget {
  final Category category;

  const CategoryContactsScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryContactsScreen> createState() => _CategoryContactsScreenState();
}

class _CategoryContactsScreenState extends State<CategoryContactsScreen> {
  List<Contact> _contacts = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadCategoryContacts();
  }

  Future<void> _loadCategoryContacts() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final contacts = await CategoriesService.getCategoryContacts(widget.category.id);
      
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load contacts: ${e.toString()}';
      });
    }
  }

  Future<void> _navigateToEditContacts() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddContactsToCategoryScreen(category: widget.category),
      ),
    );

    // If changes were made, reload the contacts
    if (result == true) {
      _loadCategoryContacts();
    }
  }

  Future<void> _removeContactFromCategory(Contact contact) async {
    try {
      await CategoriesService.removeContactFromCategory(widget.category.id, contact.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${contact.name} removed from ${widget.category.title}'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await CategoriesService.addContactToCategory(widget.category.id, contact);
              _loadCategoryContacts();
            },
          ),
        ),
      );
      
      _loadCategoryContacts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing contact: ${e.toString()}')),
      );
    }
  }

  List<SlidableAction> _buildSlidableActions(Contact contact) {
    return [
      SlidableAction(
        onPressed: (_) {
          // Add note functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add note functionality')),
          );
        },
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        icon: Icons.note_add,
      ),
      SlidableAction(
        onPressed: (_) {
          // Add reminder functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add reminder functionality')),
          );
        },
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        icon: Icons.alarm,
      ),
      SlidableAction(
        onPressed: (_) => _removeContactFromCategory(contact),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
      ),
    ];
  }

  String? _getContactTimestamp(Contact contact) {
    if (contact.savedTimestamp != null) {
      // Format the timestamp as needed
      return 'Saved ${_formatTimestamp(contact.savedTimestamp!)}';
    }
    return null;
  }

  String _formatTimestamp(DateTime timestamp) {
    // Get the current time
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays == 0) {
      // Today - show time
      return 'Today ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      // This week - show day of week
      final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      return weekdays[timestamp.weekday - 1];
    } else {
      // Older - show date
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  Widget _buildContentArea() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
            ElevatedButton(
              onPressed: _loadCategoryContacts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_contacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: isDark ? Colors.white54 : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No contacts in this category',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white70 : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _navigateToEditContacts,
              icon: const Icon(Icons.add),
              label: const Text('Add Contacts'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ContactsList(
      contacts: _contacts,
      onContactTap: (contact) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactViewScreen(contact: contact),
          ),
        );
      },
      actionsBuilder: (contact) => _buildSlidableActions(contact),
      timestampBuilder: _getContactTimestamp,
      showChevron: false,
      borderRadius: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFE8ECF4),
      appBar: AppBar(
        title: Text(widget.category.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEditContacts,
            tooltip: 'Edit contacts in this category',
          ),
        ],
      ),
      body: _buildContentArea(),
    );
  }
}
