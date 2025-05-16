// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:last_save/models/category.dart';
import 'package:last_save/screens/add_categories_contacts.dart';
import 'package:last_save/screens/create_category_screen.dart';
import 'package:last_save/screens/edit_category_screen.dart';
import 'package:last_save/services/categories_service.dart';
import 'package:last_save/widgets/categories/create_category_button.dart';
import 'package:last_save/widgets/categories/delete_confirmation_dialog.dart';
import 'package:last_save/widgets/common/category_slidable_item.dart';

class CategoriesSection extends StatefulWidget {
  final Function(Category)? onCategoryTap;
  
  const CategoriesSection({
    Key? key, 
    this.onCategoryTap,
  }) : super(key: key);

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> with SingleTickerProviderStateMixin {
  List<Category> _categories = [];
  bool _isLoading = true;
  
  final String _slidableGroup = 'categoryGroup';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final categories = await CategoriesService.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      debugPrint('Failed to load categories: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _navigateToCreateCategory(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateCategoryScreen()),
    );

    if (result != null && result is Category) {
      await _loadCategories();
    }
  }

  Future<String> _getCategorySubtitle(Category category) async {
    if (category.contactCount == 0) {
      return 'No contacts';
    }

    try {
      final contacts = await CategoriesService.getCategoryContacts(category.id);
      
      if (contacts.isEmpty) {
        return 'No contacts';
      }

      final firstContact = contacts.first;
      final otherCount = contacts.length - 1;
      
      if (otherCount > 0) {
        return '${firstContact.name} and $otherCount others';
      } else {
        return firstContact.name;
      }
    } catch (e) {
      return 'Error loading contacts';
    }
  }

  List<SlidableAction> _buildCategoryActions(Category category) {
    return [
      SlidableAction(
        onPressed: (_) {
          _navigateToAddContacts(category);
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        icon: Icons.person_add,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
      SlidableAction(
        onPressed: (_) {
          _navigateToEditCategory(category);
        },
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        icon: Icons.edit,
      ),
      SlidableAction(
        onPressed: (_) {
          _showDeleteConfirmation(category);
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
    ];
  }

  void _navigateToAddContacts(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddContactsToCategoryScreen(category: category),
      ),
    ).then((_) {
      _loadCategories();
    });
  }

  void _navigateToEditCategory(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCategoryScreen(category: category),
      ),
    ).then((result) {
      if (result != null) {
        _loadCategories();
      }
    });
  }

  void _showDeleteConfirmation(Category category) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return DeleteConfirmationDialog(
          category: category,
          onConfirm: () async {
            try {
              await CategoriesService.deleteCategory(category.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Category "${category.title}" deleted')),
              );
              _loadCategories();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to delete category: $e')),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          )
        else
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: SlidableAutoCloseBehavior(
                  closeWhenOpened: true,
                  closeWhenTapped: true,
                  child: Column(
                    children: [
                      ..._categories.map((category) => FutureBuilder<String>(
                        future: _getCategorySubtitle(category),
                        builder: (context, snapshot) {
                          final subtitle = snapshot.data ?? 'Loading...';
                          return CategorySlidableItem(
                            category: category,
                            subtitle: subtitle,
                            onTap: () {
                              if (widget.onCategoryTap != null) {
                                widget.onCategoryTap!(category);
                              }
                            },
                            groupTag: _slidableGroup,
                            actions: _buildCategoryActions(category),
                          );
                        },
                      )),
                      CreateCategoryButton(
                        onTap: () => _navigateToCreateCategory(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),

      ],
    );
  }
}
