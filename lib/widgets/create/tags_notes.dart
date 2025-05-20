import 'package:flutter/material.dart';

class NotesWidget extends StatelessWidget {
  final TextEditingController notesController;

  const NotesWidget({
    Key? key,
    required this.notesController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags & notes',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDark ? theme.cardColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: notesController,
            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            decoration: InputDecoration(
              hintText: 'Add notes',
              hintStyle: TextStyle(color: theme.hintColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
            ),
            maxLines: 5,
          ),
        ),
      ],
    );
  }
}
