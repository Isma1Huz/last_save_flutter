import 'package:flutter/material.dart';
import 'package:last_save/models/category.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/services/contacts_service.dart';
import 'package:last_save/utils/app_theme.dart';
import 'package:last_save/widgets/app_button.dart';

class ContactDetailsScreen extends StatefulWidget {
  final Contact contact;

  const ContactDetailsScreen({
    Key? key,
    required this.contact,
  }) : super(key: key);

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  late Contact _contact;
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final categories = await ContactsService.getCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load categories: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _showAddToCategoryDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add to Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _contact.categories.contains(category.id);
                    
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                        child: Icon(
                          category.icon,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      title: Text(category.title),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: AppTheme.primaryColor,
                            )
                          : const Icon(
                              Icons.circle_outlined,
                              color: Colors.grey,
                            ),
                      onTap: () async {
                        try {
                          if (isSelected) {
                            await ContactsService.removeContactFromCategory(
                              contactId: _contact.id,
                              categoryId: category.id,
                            );
                          } else {
                            await ContactsService.addContactToCategory(
                              contactId: _contact.id,
                              categoryId: category.id,
                            );
                          }
                          
                          // Refresh contact data
                          final contacts = await ContactsService.getContacts();
                          final updatedContact = contacts.firstWhere(
                            (c) => c.id == _contact.id,
                          );
                          
                          setState(() {
                            _contact = updatedContact;
                          });
                          
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isSelected
                                      ? 'Removed from ${category.title}'
                                      : 'Added to ${category.title}',
                                ),
                                backgroundColor: AppTheme.successColor,
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${e.toString()}'),
                                backgroundColor: AppTheme.errorColor,
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit functionality coming soon'),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Contact avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                    child: Text(
                      _contact.name.isNotEmpty ? _contact.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        fontSize: 36,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Contact name
                  Text(
                    _contact.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Contact info cards
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Phone number
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green.withOpacity(0.2),
                              child: const Icon(
                                Icons.phone,
                                color: Colors.green,
                              ),
                            ),
                            title: const Text('Phone'),
                            subtitle: Text(_contact.phoneNumber),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.message,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Message functionality coming soon'),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.phone,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Call functionality coming soon'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          
                          // Email if available
                          if (_contact.email != null)
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.red.withOpacity(0.2),
                                child: const Icon(
                                  Icons.email,
                                  color: Colors.red,
                                ),
                              ),
                              title: const Text('Email'),
                              subtitle: Text(_contact.email!),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.email,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Email functionality coming soon'),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Categories section
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Categories',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text('Add'),
                                onPressed: _showAddToCategoryDialog,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _contact.categories.isEmpty
                              ? const Text(
                                  'Not in any category',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              : Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _contact.categories.map((categoryId) {
                                    final category = _categories.firstWhere(
                                      (c) => c.id == categoryId,
                                      orElse: () => Category(
                                        id: categoryId,
                                        title: 'Unknown',
                                        icon: Icons.category,
                                      ),
                                    );
                                    
                                    return Chip(
                                      avatar: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: Icon(
                                          category.icon,
                                          color: AppTheme.primaryColor,
                                          size: 16,
                                        ),
                                      ),
                                      label: Text(category.title),
                                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                                      labelStyle: TextStyle(
                                        color: AppTheme.primaryColor,
                                      ),
                                      deleteIcon: const Icon(
                                        Icons.close,
                                        size: 16,
                                      ),
                                      onDeleted: () async {
                                        try {
                                          await ContactsService.removeContactFromCategory(
                                            contactId: _contact.id,
                                            categoryId: category.id,
                                          );
                                          
                                          // Refresh contact data
                                          final contacts = await ContactsService.getContacts();
                                          final updatedContact = contacts.firstWhere(
                                            (c) => c.id == _contact.id,
                                          );
                                          
                                          setState(() {
                                            _contact = updatedContact;
                                          });
                                          
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Removed from ${category.title}'),
                                                backgroundColor: AppTheme.successColor,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Error: ${e.toString()}'),
                                                backgroundColor: AppTheme.errorColor,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    );
                                  }).toList(),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}