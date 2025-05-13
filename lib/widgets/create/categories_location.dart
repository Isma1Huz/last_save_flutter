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
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Category',
        border: UnderlineInputBorder(),
      ),
      value: selectedCategory,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Current Location',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          currentAddress ?? 'Fetching location...',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
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
    return TextFormField(
      controller: meetingEventController,
      decoration: const InputDecoration(
        labelText: 'Where we met',
        border: UnderlineInputBorder(),
      ),
    );
  }
}