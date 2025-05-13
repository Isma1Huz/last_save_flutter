import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final bool hasSearchQuery;
  final String searchQuery;

  const EmptyState({
    super.key,
    required this.hasSearchQuery,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            hasSearchQuery
                ? 'No contacts found matching "$searchQuery"'
                : 'No contacts found on this device',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
