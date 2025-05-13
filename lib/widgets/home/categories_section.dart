import 'package:flutter/material.dart';
import 'package:last_save/models/category.dart';
import 'package:last_save/screens/create_category_screen.dart';
import 'package:last_save/services/categories_service.dart';

class CategoriesSection extends StatefulWidget {
  final Function(Category)? onCategoryTap;
  
  const CategoriesSection({
    Key? key, 
    this.onCategoryTap,
  }) : super(key: key);

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  List<Category> _categories = [];
  bool _isLoading = true;

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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Column(
              children: [
                ..._categories.map((category) => CategoryListItem(
                      category: category,
                      onTap: () {
                        if (widget.onCategoryTap != null) {
                          widget.onCategoryTap!(category);
                        }
                      },
                    )),
                CreateCategoryButton(
                  onTap: () => _navigateToCreateCategory(context),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class CategoryListItem extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryListItem({
    Key? key, 
    required this.category, 
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String subtitle = '';
    
    if (category.contactCount == 0) {
      subtitle = 'James smith and ${category.contactCount - 1} others';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0), 
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8), 
        leading: const CircleAvatar(
          backgroundColor: Colors.black,
          radius: 16, 
          child: Icon(
            Icons.person, 
            color: Colors.white,
            size: 16, 
          ),
        ),
        title: Text(
          category.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500, 
            fontSize: 14, 
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class CreateCategoryButton extends StatelessWidget {
  final VoidCallback onTap;

  const CreateCategoryButton({
    Key? key, 
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0), 
        
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8), 
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade300,
          radius: 16, 
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 16, 
          ),
        ),
        title: const Text(
          'Create category',
          style: TextStyle(
            fontWeight: FontWeight.w500, 
            fontSize: 14, 
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}