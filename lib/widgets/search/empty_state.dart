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
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            hasSearchQuery
                ? 'No contacts found matching "$searchQuery"'
                : 'No contacts found on this device',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}
