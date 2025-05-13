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
    return Scaffold(
      backgroundColor: const Color(0xFFE8ECF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8ECF4),
        title: const Center(
          child: Text('Create Category'),
        ),
        actions: [
          Container(
                margin: const EdgeInsets.only(right: 10),
                child:TextButton(
                  onPressed: _isLoading ? null : _saveCategory,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    backgroundColor: const Color(0xFF00BCD4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
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
            const CategoryIconSelector(),
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
  const CategoryIconSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.person,
          size: 40,
          color: Colors.black,
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
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Category Name',
        border: OutlineInputBorder(),
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
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Description (Optional)',
        border: OutlineInputBorder(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Icon',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
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
            return GestureDetector(
              onTap: () => onIconSelected(index),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                      : null,
                ),
                child: Icon(
                  Category.availableIcons[index],
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade700,
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
