import 'package:flutter/material.dart';

// Category Widget
class CategoryWidget extends StatelessWidget {
  final String? selectedCategory;
  final List<String> categories;
  final Function(String?) onCategoryChanged;

  const CategoryWidget({
    Key? key,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Category',
        labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
        border: const UnderlineInputBorder(),
      ),
      value: selectedCategory,
      dropdownColor: theme.cardColor,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      items: categories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: onCategoryChanged,
    );
  }
}

// Location Widget
class LocationWidget extends StatelessWidget {
  final String? currentAddress;

  const LocationWidget({
    Key? key,
    required this.currentAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Location',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          currentAddress ?? 'Fetching location...',
          style: TextStyle(
            fontSize: 14,
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}

// Meeting Event Widget
class MeetingEventWidget extends StatelessWidget {
  final TextEditingController meetingEventController;

  const MeetingEventWidget({
    Key? key,
    required this.meetingEventController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextFormField(
      controller: meetingEventController,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: InputDecoration(
        labelText: 'Where we met',
        labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
        border: const UnderlineInputBorder(),
      ),
    );
  }
}
