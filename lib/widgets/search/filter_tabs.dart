import 'package:flutter/material.dart';
import 'package:last_save/models/category.dart';
import 'package:last_save/services/categories_service.dart';
import 'package:last_save/screens/create_category_screen.dart';

class FilterTabs extends StatefulWidget {
  final Function(int) onTabChanged;
  final int initialTab;
  final Function(String)? onCategorySelected;

  const FilterTabs({
    super.key,
    required this.onTabChanged,
    this.initialTab = 0,
    this.onCategorySelected,
  });

  @override
  State<FilterTabs> createState() => _FilterTabsState();
}

class _FilterTabsState extends State<FilterTabs> {
  late int _selectedTab;
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
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
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading categories: $e');
      setState(() {
        _isLoading = false;
      });
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: isDark ? theme.scaffoldBackgroundColor : Colors.white,
      child: _isLoading
          ? Center(
              child: SizedBox(
                height: 20, 
                width: 20, 
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTab(0, 'All'),
                  ..._categories.asMap().entries.map((entry) {
                    return _buildTab(entry.key + 1, entry.value.title, categoryId: entry.value.id);
                  }).toList(),
                  _buildAddButton(context),
                ],
              ),
            ),
    );
  }

  Widget _buildTab(int index, String label, {String? categoryId}) {
    final isSelected = _selectedTab == index;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Define colors based on theme
    final selectedBgColor = isDark 
        ? theme.colorScheme.primary.withOpacity(0.3) 
        : theme.colorScheme.primary.withOpacity(0.1);
    
    final unselectedBgColor = isDark 
        ? theme.cardColor 
        : Colors.grey[200];
    
    final selectedTextColor = theme.colorScheme.primary;
    
    final unselectedTextColor = isDark 
        ? theme.textTheme.bodyMedium?.color 
        : Colors.grey[800];
    
    final borderColor = isDark 
        ? theme.dividerColor 
        : Colors.grey[300]!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
          widget.onTabChanged(index);
          
          if (categoryId != null && widget.onCategorySelected != null) {
            widget.onCategorySelected!(categoryId);
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? selectedBgColor : unselectedBgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? selectedTextColor : unselectedTextColor,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final bgColor = isDark 
        ? theme.cardColor 
        : Colors.grey[200];
    
    final iconColor = isDark 
        ? theme.iconTheme.color 
        : Colors.grey[800];
    
    final borderColor = isDark 
        ? theme.dividerColor 
        : Colors.grey[300]!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: () => _navigateToCreateCategory(context),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Icon(
            Icons.add,
            size: 18,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
