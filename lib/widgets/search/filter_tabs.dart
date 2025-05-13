import 'package:flutter/material.dart';

class FilterTabs extends StatefulWidget {
  final Function(int) onTabChanged;
  final int initialTab;

  const FilterTabs({
    super.key,
    required this.onTabChanged,
    this.initialTab = 0,
  });

  @override
  State<FilterTabs> createState() => _FilterTabsState();
}

class _FilterTabsState extends State<FilterTabs> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTab(0, 'All'),
            _buildTab(1, 'Missed'),
            _buildTab(2, 'Contacts'),
            _buildTab(3, 'Non-Spam'),
            _buildTab(4, 'Spam'),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final isSelected = _selectedTab == index;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
          widget.onTabChanged(index);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue[800] : Colors.grey[800],
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
