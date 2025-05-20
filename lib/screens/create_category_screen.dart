// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:last_save/models/category.dart';
import 'package:last_save/services/categories_service.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({Key? key}) : super(key: key);

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _selectedIconIndex = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newCategory = await CategoriesService.addCategory(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        icon: Category.availableIcons[_selectedIconIndex],
      );

      if (mounted) {
        Navigator.pop(context, newCategory);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create category: $e')),
        );
      }
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Define theme-aware colors
    final backgroundColor = isDark ? theme.scaffoldBackgroundColor : const Color(0xFFE8ECF4);
    final primaryColor = theme.colorScheme.primary;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Center(
          child: Text('Create Category'),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: _isLoading ? null : _saveCategory,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            CategoryIconSelector(isDark: isDark),
            const SizedBox(height: 24),
            CategoryNameField(controller: _titleController),
            const SizedBox(height: 16),
            CategoryDescriptionField(controller: _descriptionController),
            const SizedBox(height: 24),
            IconSelectionGrid(
              selectedIconIndex: _selectedIconIndex,
              onIconSelected: (index) {
                setState(() {
                  _selectedIconIndex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryIconSelector extends StatelessWidget {
  final bool isDark;
  
  const CategoryIconSelector({Key? key, required this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isDark ? theme.cardColor : Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.person,
          size: 40,
          color: isDark ? theme.iconTheme.color : Colors.black,
        ),
      ),
    );
  }
}

class CategoryNameField extends StatelessWidget {
  final TextEditingController controller;

  const CategoryNameField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextFormField(
      controller: controller,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: InputDecoration(
        labelText: 'Category Name',
        border: const OutlineInputBorder(),
        labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor ?? 
                  (theme.brightness == Brightness.dark ? theme.cardColor : Colors.white),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a category name';
        }
        return null;
      },
    );
  }
}

class CategoryDescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const CategoryDescriptionField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextFormField(
      controller: controller,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: InputDecoration(
        labelText: 'Description (Optional)',
        border: const OutlineInputBorder(),
        labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor ?? 
                  (theme.brightness == Brightness.dark ? theme.cardColor : Colors.white),
      ),
      maxLines: 3,
    );
  }
}

class IconSelectionGrid extends StatelessWidget {
  final int selectedIconIndex;
  final Function(int) onIconSelected;

  const IconSelectionGrid({
    Key? key,
    required this.selectedIconIndex,
    required this.onIconSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Icon',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: Category.availableIcons.length,
          itemBuilder: (context, index) {
            final isSelected = index == selectedIconIndex;
            final primaryColor = theme.colorScheme.primary;
            
            return GestureDetector(
              onTap: () => onIconSelected(index),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected 
                      ? primaryColor.withOpacity(0.1) 
                      : isDark ? theme.cardColor : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: primaryColor, width: 2)
                      : null,
                ),
                child: Icon(
                  Category.availableIcons[index],
                  color: isSelected 
                      ? primaryColor 
                      : isDark ? theme.iconTheme.color : Colors.grey.shade700,
                  size: 28,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
