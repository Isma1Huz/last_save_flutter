import 'dart:async';
import 'package:flutter/material.dart';
import 'package:last_save/models/contact.dart';
import 'package:last_save/services/categories_service.dart';

class SelectableContactsList extends StatefulWidget {
  final List<Contact> contacts;
  final Set<String> selectedContactIds;
  final Function(Contact) onContactTap;
  final String? categoryId;

  const SelectableContactsList({
    Key? key,
    required this.contacts,
    required this.selectedContactIds,
    required this.onContactTap,
    this.categoryId,
  }) : super(key: key);

  @override
  State<SelectableContactsList> createState() => _SelectableContactsListState();
}

class _SelectableContactsListState extends State<SelectableContactsList> {
  Map<String, bool> _initialSelectionState = {};
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null) {
      _loadInitialSelectionState();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _loadInitialSelectionState() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      for (final contact in widget.contacts) {
        final isInCategory = await CategoriesService.isContactInCategory(
          widget.categoryId!, 
          contact.id
        );
        
        _initialSelectionState[contact.id] = isInCategory;
        
        if (isInCategory && !widget.selectedContactIds.contains(contact.id)) {
          widget.selectedContactIds.add(contact.id);
        }
      }
    } catch (e) {
      debugPrint('Error loading initial selection state: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return ListView.builder(
      itemCount: widget.contacts.length,
      itemBuilder: (context, index) {
        final contact = widget.contacts[index];
        final isSelected = widget.selectedContactIds.contains(contact.id);
        final wasInitiallySelected = _initialSelectionState[contact.id] ?? false;
        
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: contact.photo != null ? MemoryImage(contact.photo!) : null,
            child: contact.photo == null
                ? Text(contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?')
                : null,
          ),
          title: Text(contact.name),
          subtitle: Text(contact.phoneNumber),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (wasInitiallySelected)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Added',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Checkbox(
                value: isSelected,
                onChanged: (value) => widget.onContactTap(contact),
              ),
            ],
          ),
          onTap: () => widget.onContactTap(contact),
        );
      },
    );
  }
}
