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
        onPressed: (_) => _removeContactFromCategory(contact),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Remove',
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
      ),
    ];
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
      showChevron: true,
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
