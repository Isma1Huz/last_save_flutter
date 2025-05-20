// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:last_save/screens/home_screen.dart';
import 'package:last_save/screens/search_screen.dart';
import 'package:last_save/screens/settings.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    SearchScreen(), 
    SettingsScreen()
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    
    setState(() {
      _selectedIndex = index;
    });
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    final backgroundColor = isDarkMode
        ? theme.scaffoldBackgroundColor
        : theme.cardColor;
    
    final shadowColor = isDarkMode
        ? Colors.black.withOpacity(0.3)
        : Colors.grey.withOpacity(0.2);
    
    final border = isDarkMode
        ? Border(
            top: BorderSide(
              color: Colors.grey[700]!,
              width: 0.5,
            ),
          )
        : null;
    
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: isDarkMode 
            ? [] 
            : [
                BoxShadow(
                  color: shadowColor,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
        border: border,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, 'Home', 0),
          _buildNavItem(Icons.search, 'Search', 1),
          _buildNavItem(Icons.person_outline, 'Menu', 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    final theme = Theme.of(context);
    
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = theme.brightness == Brightness.light
        ? Colors.black.withOpacity(0.7)
        : theme.colorScheme.onSurface;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? selectedColor : unselectedColor,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? selectedColor : unselectedColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
