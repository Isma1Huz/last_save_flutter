import 'package:flutter/material.dart';
import 'package:last_save/screens/home_screen.dart';
import 'package:last_save/screens/search_screen.dart';
// import 'package:last_save/screens/menu_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    SearchScreen(), 
    Placeholder()// Create this as a placeholder if not already present
    // MenuScreen(),   // Create this as a placeholder if not already present
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
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
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.teal : Colors.black,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.teal : Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
