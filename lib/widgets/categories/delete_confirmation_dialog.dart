import 'package:flutter/material.dart';
import 'package:last_save/models/category.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Category category;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    Key? key,
    required this.category,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Category'),
      content: Text('Are you sure you want to delete "${category.title}"? This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: const Text('DELETE', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
