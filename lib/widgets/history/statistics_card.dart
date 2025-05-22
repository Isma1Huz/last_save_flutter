import 'package:flutter/material.dart';

class StatisticsCard extends StatelessWidget {
  final String title;
  final Widget child;

  const StatisticsCard({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Card(
      elevation: 0,
      color: isDark ? Colors.grey.shade900 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Text(
              title,
              style: theme.textTheme.titleLarge,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
